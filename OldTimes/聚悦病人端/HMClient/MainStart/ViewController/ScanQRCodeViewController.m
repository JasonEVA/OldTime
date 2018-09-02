//
//  ScanQRCodeViewController.m
//  HMClient
//
//  Created by lkl on 16/8/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CommonEncrypt.h"
#import "ServiceInfo.h"
#import "ServiceOrder.h"

#define kBgImgX             45*kScreenScale
#define kBgImgY             60*kScreenScale
#define kBgImgWidth         230*kScreenScale

#define kScrollLineHeight   2*kScreenScale

typedef enum : NSUInteger {
    QRCodeResult_Json,          //需要解析的Json
    QRCodeResult_WebUrl,        //Http url
    QRCodeResult_Unkonwn,       //未知格式
} QRCodeResultType;

@interface ScanQRCodeViewController ()
<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,
TaskObserver,
UIAlertViewDelegate>
{
    UIImageView *bgImgView;
    UIImageView *scrollLineView;
    UILabel     *lbContent;
    UIButton    *openPhotoBtn;
    
    NSInteger serviceUpId;
    
    BOOL isStop;
}

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) CADisplayLink *link;
@property (assign, nonatomic) BOOL up;
@end

@implementation ScanQRCodeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //判断是否有相机权限
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        [self showAlertMessage:@"开启相机才能扫描二维码哦" cancelTitle:@"残忍拒绝" cancelClicked:nil confirmTitle:@"去开启" confirmClicked:^{
            
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }];
        return;
    }
    
    [self.session startRunning];
    //计时器添加到循环中去
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

    if (isStop) {
        [self.session stopRunning];
        [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session stopRunning];
    if (self.link) {
        [self.link invalidate];
        self.link = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.navigationItem setTitle:@"二维码"];
    _up = YES;
    
    [self session];
    [self initWithSubViews];
    
}

- (CADisplayLink *)link{

    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(LineAnimation)];
    }
    return _link;
}
#pragma mark - 线条运动的动画
- (void)LineAnimation
{
    if (_up == YES)
    {
        CGFloat y = scrollLineView.frame.origin.y;
        y += 2;
        [scrollLineView setFrame:CGRectMake(kBgImgX, y, kBgImgWidth, kScrollLineHeight)];
        if (y >= (kBgImgY+kBgImgWidth-kScrollLineHeight))
        {
            _up = NO;
        }
    }else{
        CGFloat y = scrollLineView.frame.origin.y;
        y -= 2;
        [scrollLineView setFrame:CGRectMake(kBgImgX, y, kBgImgWidth, kScrollLineHeight)];
        if (y <= kBgImgY)
        {
            _up = YES;
        }
    }
}

- (void)initWithSubViews
{
    bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kBgImgX, kBgImgY, kBgImgWidth, kBgImgWidth)];
    [self.view addSubview:bgImgView];
    [bgImgView setImage:[UIImage imageNamed:@"icon_two_box"]];
    
    scrollLineView = [[UIImageView alloc]initWithFrame:CGRectMake(kBgImgX, kBgImgY, kBgImgWidth, kScrollLineHeight)];
    [self.view addSubview:scrollLineView];
    [scrollLineView setImage:[UIImage imageNamed:@"icon_two_line"]];
    
    lbContent = [[UILabel alloc] init];
    [self.view addSubview:lbContent];
    [lbContent setText:@"将二维码放入框内，即可自动扫描"];
    [lbContent setFont:[UIFont systemFontOfSize:14.0]];
    [lbContent setTextColor:[UIColor whiteColor]];
    [lbContent setTextAlignment:NSTextAlignmentCenter];

    openPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:openPhotoBtn];
    [openPhotoBtn setTitle:@"从相册选取" forState:UIControlStateNormal];
    [openPhotoBtn setTintColor:[UIColor whiteColor]];
    [openPhotoBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    
    [openPhotoBtn addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    [self subViewsLayout];
}

- (void)subViewsLayout
{
    [lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImgView.mas_bottom).offset(10);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(@20);
    }];
    
    [openPhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbContent.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
}

- (AVCaptureSession *)session
{
    if (!_session)
    {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
        if (input == nil) {
            return nil;
        }
    
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        AVCaptureSession *session = [[AVCaptureSession alloc]init];
        [session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([session canAddInput:input]) {
            [session addInput:input];
        }
        if ([session canAddOutput:output]) {
            [session addOutput:output];
        }
        
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        
        AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
        [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        previewLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:previewLayer atIndex:0];

        CGRect rect = CGRectMake(kBgImgY/ScreenHeight, kBgImgX/ScreenWidth, kBgImgWidth/ScreenHeight, kBgImgWidth/ScreenWidth);
        output.rectOfInterest = rect;
        
        UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self.view addSubview:maskView];
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
        [rectPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(kBgImgX, kBgImgY, kBgImgWidth, kBgImgWidth) cornerRadius:1] bezierPathByReversingPath]];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = rectPath.CGPath;
        maskView.layer.mask = shapeLayer;
        
        _session = session;
    }
    return _session;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 调用相册

- (void)openPhoto
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        return;
    }

    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

//相册获取的照片进行处理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(pickImage);
    CIImage *ciImage = [CIImage imageWithData:imageData];
    
    //从选中的图片中读取二维码数据
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    
    NSArray *feature = [detector featuresInImage:ciImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (feature.count)
    {
        for (CIQRCodeFeature *result in feature)
        {
            if ([result isKindOfClass:[CIQRCodeFeature class]])
            {
                NSString *urlStr = ((CIQRCodeFeature *)result).messageString;
                
                [self showInWebViewWithURLMessage:urlStr Success:^(NSString *token) {
                    
                } Failure:^(NSError *error) {
                    
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"该信息无法跳转，数据为：" message:urlStr delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"重新扫描", nil];
                    [alert setTag:0x1100];
                    [alert show];
                }];
                
                break;
            }
        }
    }else
    {
        isStop = YES;
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"无法识别该二维码" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"重新扫描", nil];
        [alert setTag:0x1100];
        [alert show];
    }
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
// 扫描到数据时会调用
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{

    if (metadataObjects.count > 0)
    {
        AVMetadataMachineReadableCodeObject *obj = [metadataObjects lastObject];
        
        if (obj)
        {
            [self showInWebViewWithURLMessage:[obj stringValue] Success:^(NSString *token) {
                
            } Failure:^(NSError *error) {
                
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"该信息无法跳转，数据为：" message:[obj stringValue] delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"重新扫描", nil];
                [alert setTag:0x1100];
                [alert show];
                
            }];
        }
    }
}


-(void)showInWebViewWithURLMessage:(NSString *)message Success:(void (^)(NSString *token))success Failure:(void (^)(NSError *error))failure
{
    QRCodeResultType resultType = [self qrCodeResultTypeFrom:message];
    switch (resultType)
    {
        case QRCodeResult_WebUrl:
        {
            //判断是否是商城URL
            NSURL* qrUrl = [NSURL URLWithString:message];
            NSString* qrUrlPath = [qrUrl path];
            NSRange pathRange = [qrUrlPath rangeOfString:@"/fwx/detail.htm"];
            if (pathRange.location != NSNotFound) {
                NSDictionary* queryDictionary = [qrUrl dictionaryWithQuery];
                if (queryDictionary)
                {
                    NSString* upId = [queryDictionary valueForKey:@"upId"];
                    if (upId && [upId isPureInt] && upId > 0)
                    {
                        //跳转到详情界面 SecondEditionServiceDetailViewController
                        [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceDetailViewController" ControllerObject:queryDictionary];
                        success(@"成功跳转");
                        return;
                    }
                }

            }
            
            //WebUrl，跳转到相应地址
//            [HMViewControllerManager createViewControllerWithControllerName:@"ScanQRCodeBrowserViewController" FromControllerId:nil ControllerObject:message];
            [HMViewControllerManager createViewControllerWithControllerName:@"HMWebViewController" ControllerObject:message];
            success(@"成功跳转");
        }
            break;
        case QRCodeResult_Json:
        {
            //Json
            NSDictionary* dicResult = [NSDictionary JSONValue:message];
            NSString* dataValue = [dicResult valueForKey:@"data"];
            //解密Json数据
            NSString* sResult = [CommonEncrypt DESStringDecryp:dataValue WithKey:@"yuyou1208"];
            NSLog(@"sResult %@", sResult);
            NSDictionary* dicData = [NSDictionary JSONValue:sResult];
            if (!dicData && ![dicData isKindOfClass:[NSDictionary class]])
            {
                //不是规定格式的Json
                NSError *error;
                failure(error);
                break;
            }
            NSString* sType = [dicData valueForKey:@"type"];
            NSDictionary* dicParam = [dicData valueForKey:@"param"];
            if (!sType || ![sType isKindOfClass:[NSString class]] || 0 == sType.length)
            {
                //没能获取到数据Type，无法解析
                NSError *error;
                failure(error);
                break;
            }
            
            if ([sType isEqualToString:@"service"])
            {
                //服务订购二维码
                if (!dicParam || ![dicParam isKindOfClass:[NSDictionary class]])
                {
                    //没能获取到数据参数，无法处理
                    NSError *error;
                    failure(error);
                    break;
                }
                
                NSNumber* numLevel = [dicParam valueForKey:@"serviceLevel"];
                NSNumber* numUpId = [dicParam valueForKey:@"upId"];
                if (!numLevel && ![numLevel isKindOfClass:[NSNumber class]])
                {
                    NSError *error;
                    failure(error);
                    break;
                }
                if (!numUpId && ![numUpId isKindOfClass:[NSNumber class]])
                {
                    NSError *error;
                    failure(error);
                    break;
                }
                switch (numLevel.integerValue)
                {
                    case 3:
                        //基础服务
                    {
                        [self startCheckServiceForOrder:dicParam];
                    }
                        break;
                        
                    default:
                    {
                        //跳转到服务详情
                        ServiceInfo* serviceInfo = [[ServiceInfo alloc]init];
                        [serviceInfo setUpId:numUpId.integerValue];
//                        [HMViewControllerManager createViewControllerWithControllerName:@"ServiceDetailStartViewController" FromControllerId:nil ControllerObject:serviceInfo];
                        [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceDetailViewController" ControllerObject:[NSString stringWithFormat:@"%ld", serviceInfo.upId]];
                        
                    }
                        break;
                }

                
                break;
            }
            
        }
            break;
        default:
        {
            NSError *error;
            failure(error);
        }
            break;
    }
    
    //TODO：停止扫描二维码
    [self.session stopRunning];
    [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:message]])
//    {
//        success(@"成功跳转");
//        [HMViewControllerManager createViewControllerWithControllerName:@"ScanQRCodeBrowserViewController" ControllerObject:message];
//    }else
//    {
//        NSError *error;
//        failure(error);
//    }
}


//判断二维码结果字符串对应的类型
- (QRCodeResultType) qrCodeResultTypeFrom:(NSString*) message
{
    QRCodeResultType resultType = QRCodeResult_Unkonwn;
    if (!message || message.length < 6)
    {
        return resultType;
    }
    NSURL* qrUrl = [NSURL URLWithString:message];
    if (qrUrl)
    {
        //是URL, 判断是否是web的url
        NSString* scheme = [qrUrl scheme];
        if (scheme && 0 < scheme.length)
        {
            if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"])
            {
                //http url
                resultType = QRCodeResult_WebUrl;
                return resultType;
            }
        }
    }
    
    NSDictionary* dicResult = [NSDictionary JSONValue:message];
    if (dicResult && [dicResult isKindOfClass:[NSDictionary class]])
    {
        //Json
        NSString* dataValue = [dicResult valueForKey:@"data"];
        if (dataValue && [dataValue isKindOfClass:[NSString class]])
        {
            //正确的Json格式
            resultType = QRCodeResult_Json;
            return resultType;
        }
        
        return resultType;
    }
    return resultType;
}

//获取二维码对应服务订购情况, 判断是否能够购买
- (void) startCheckServiceForOrder:(NSDictionary*) dicParam
{
    
    NSNumber* numUpId = [dicParam valueForKey:@"upId"];
    if (!numUpId && ![numUpId isKindOfClass:[NSNumber class]]) {
        return;
    }
    
    serviceUpId = numUpId.integerValue;
    
    [self.view showWaitView];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", numUpId.integerValue] forKey:@"upId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserServiceStatusTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - TaskObservice

- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"UserServiceStatusTask"])
    {
        //验证服务二维码结果返回
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResp = (NSDictionary*) taskResult;
            NSString* message = [dicResp valueForKey:@"message"];
            NSNumber* numType = [dicResp valueForKey:@"type"];
            
            if (!numType || ![numType isKindOfClass:[NSNumber class]])
            {
                return;
            }
            
            switch (numType.integerValue)
            {
                case 0:
                {
                    //可订购
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alert setTag:0x1000];
                    [alert show];
                }
                    break;
                case 1:
                {
                    //不可订购
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"重新扫描", nil];
                    [alert setTag:0x1100];
                    [alert show];
                }
                    break;
                default:
                    break;
            }
        }
    }
    if ([taskname isEqualToString:@"CreateServiceOrderTask"])
    {
        //购买基本服务
        if (taskResult && [taskResult isKindOfClass:[ServiceOrder class]])
        {
            ServiceOrder* serviceOrder = (ServiceOrder*) taskResult;
             [HMViewControllerManager createViewControllerWithControllerName:@"OrderDetailStartViewController" ControllerObject:[NSString stringWithFormat:@"%ld", serviceOrder.orderId]];
        }

        
        //刷新用户服务
        [[TaskManager shareInstance] createTaskWithTaskName:@"CheckUserServiceTask" taskParam:nil TaskObserver:self];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 1:
        {
            switch (alertView.tag)
            {
                case 0x1100:
                {
                    //TODO:重新扫描
                    isStop = NO;
                    [self.session startRunning];
                    
                    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
                }
                    break;
                case 0x1000:
                {
                    //可订购
                    
                    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
                    [dicPost setValue:[NSNumber numberWithInteger:serviceUpId]  forKey:@"upId"];
                    [dicPost setValue:@"SERVICE" forKey:@"orderTypeCode"];
                    [dicPost setValue:@"IOS" forKey:@"sourceCode"];
                    
                    [self.view showWaitView];
                    //直接创建订单
                    [[TaskManager shareInstance] createTaskWithTaskName:@"CreateServiceOrderTask" taskParam:dicPost TaskObserver:self];
                    
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        default:
            break;
    }
    
}
@end
