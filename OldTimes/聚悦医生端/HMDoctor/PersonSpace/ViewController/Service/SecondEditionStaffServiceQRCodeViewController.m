//
//  SecondEditionStaffServiceQRCodeViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/6/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SecondEditionStaffServiceQRCodeViewController.h"

@interface ServiceQRCodeView : UIView

@property (nonatomic, readonly) UIView* titleView;
@property (nonatomic, readonly) UILabel* titleLable;

@property (nonatomic, readonly) UIView* priceView;
@property (nonatomic, readonly) UILabel* priceLable;
@property (nonatomic, readonly) UILabel* priceUnitLable;

@property (nonatomic, readonly) UILabel* shareNoticeLable;
@property (nonatomic, readonly) UIImageView* qrImageView;

- (void) setShareUrl:(NSString*) shareUrl;

- (void) setServiceInfo:(ServiceInfo*) serviceInfo;
@end


@implementation ServiceQRCodeView


@synthesize titleView = _titleView;
@synthesize titleLable = _titleLable;

@synthesize priceView = _priceView;
@synthesize priceLable = _priceLable;
@synthesize priceUnitLable = _priceUnitLable;

@synthesize qrImageView = _qrImageView;

@synthesize shareNoticeLable = _shareNoticeLable;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(@100);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView).with.offset(16);
        make.centerX.equalTo(self.titleView);
        make.width.lessThanOrEqualTo(self.titleView);
    }];
    
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleView);
        make.top.equalTo(self.titleLable.mas_bottom).with.offset(14);
        
    }];
    
    [self.priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceView);
        make.top.bottom.equalTo(self.priceView);
    }];
    
    [self.priceUnitLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLable.mas_right);
        make.right.equalTo(self.priceView);
        make.bottom.equalTo(self.priceView).with.offset(-4);
    }];
    
    [self.shareNoticeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).with.offset(-35);
    }];
    
    [self.qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 35 - 80, kScreenWidth - 35 - 80));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.shareNoticeLable.mas_top).with.offset(-34);
    }];
}


- (void) setServiceInfo:(ServiceInfo*) serviceInfo
{
    [self.titleLable setText:serviceInfo.productName];
    //    [self.priceUnitLable setHidden:(serviceInfo.salePrice <= 0)];
    
    if (serviceInfo.salePrice == 0) {
        [self.priceLable setText:@"免费"];
        [self.priceUnitLable setText:nil];
        return;
    }
    
    if ([CommonFuncs isInteger:serviceInfo.salePrice]) {
        [self.priceLable setText:[NSString stringWithFormat:@"%ld", (NSInteger)serviceInfo.salePrice]];
    }
    else
    {
        [self.priceLable setText:[NSString stringWithFormat:@"%.2f", serviceInfo.salePrice]];
    }
}

- (void) setShareUrl:(NSString*) shareUrl
{
    if (!shareUrl) {
        return;
    }
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData *data = [shareUrl dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    
    
    self.qrImageView.image =  [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:kScreenWidth - 80 - 35];
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - settingAndGetting
- (UIView*) titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        [self addSubview:_titleView];
        [_titleView setBackgroundColor:[UIColor commonBackgroundColor]];
    }
    
    return _titleView;
}

- (UILabel*) titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        [self.titleView addSubview:_titleLable];
        
        [_titleLable setTextColor:[UIColor commonTextColor]];
        [_titleLable setFont:[UIFont systemFontOfSize:20]];
        
    }
    return _titleLable;
}

- (UIView*) priceView
{
    if (!_priceView) {
        _priceView = [[UIView alloc] init];
        [self.titleView addSubview:_priceView];
    }
    
    return _priceView;
}

- (UILabel*) priceLable
{
    if (!_priceLable) {
        _priceLable = [[UILabel alloc] init];
        [self.priceView addSubview:_priceLable];
        
        [_priceLable setTextColor:[UIColor mainThemeColor]];
        [_priceLable setFont:[UIFont systemFontOfSize:26]];
        
    }
    
    return _priceLable;
}

- (UILabel*) priceUnitLable
{
    if (!_priceUnitLable) {
        _priceUnitLable = [[UILabel alloc] init];
        [self.priceView addSubview:_priceUnitLable];
        
        [_priceUnitLable setTextColor:[UIColor mainThemeColor]];
        [_priceUnitLable setFont:[UIFont systemFontOfSize:14]];
        [_priceUnitLable setText:@"元"];
    }
    
    return _priceUnitLable;
}


- (UIImageView*) qrImageView
{
    if (!_qrImageView) {
        _qrImageView = [[UIImageView alloc] init];
        [self addSubview:_qrImageView];
    }
    return _qrImageView ;
}

- (UILabel*) shareNoticeLable
{
    if (!_shareNoticeLable) {
        _shareNoticeLable = [[UILabel alloc] init];
        [self addSubview:_shareNoticeLable];
        
        [_shareNoticeLable setFont:[UIFont systemFontOfSize:14]];
        [_shareNoticeLable setTextColor:[UIColor commonRedColor]];
        [_shareNoticeLable setAttributedText:[self getAttributWithChangePart:@"微信" UnChangePart:@"扫描二维码，获取商品详情" UnChangeColor:[UIColor mainThemeColor] UnChangeFont:[UIFont systemFontOfSize:14]]];
        
//        [_shareNoticeLable setText:@"扫描二维码，获取商品详情"];
//        [_shareNoticeLable setTextColor:[UIColor mainThemeColor]];
//        [_shareNoticeLable setFont:[UIFont systemFontOfSize:14]];
    }
    return _shareNoticeLable;
}

- (NSAttributedString *)getAttributWithChangePart:(NSString *)changePart UnChangePart:(NSString *)unChangePart UnChangeColor:(UIColor *)unChangeColor UnChangeFont:(UIFont *)unChangeFont{
    
    NSString *allStr = [NSString stringWithFormat:@"%@%@",changePart,unChangePart];
    NSRange unChangePartRange = [allStr rangeOfString:unChangePart];
    NSMutableAttributedString *allAttStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    if (unChangeColor) {
        [allAttStr addAttribute:NSForegroundColorAttributeName value:unChangeColor range:unChangePartRange];
    }
    if (unChangeFont) {
        [allAttStr addAttribute:NSFontAttributeName value:unChangeFont range:unChangePartRange];
    }
    return allAttStr;
}
@end


@interface SecondEditionStaffServiceQRCodeViewController ()
<TaskObserver>
@property (nonatomic, readonly) ServiceInfo* serviceInfo;

@property (nonatomic, readonly) ServiceQRCodeView* qrCodeView;

@end

@implementation SecondEditionStaffServiceQRCodeViewController

@synthesize qrCodeView = _qrCodeView;

- (id) initWithServiceInfo:(ServiceInfo*) serviceInfo
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _serviceInfo = serviceInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"分享"];
    
    //隐藏底部黑线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    
    [self.view setBackgroundColor:[UIColor mainThemeColor]];
    
    [self.qrCodeView setServiceInfo:self.serviceInfo];
    
    UIBarButtonItem* closeButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_navi_close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeController)];
    [self.navigationItem setLeftBarButtonItem:closeButtonItem];
    
    //获取分享链接 ShareProductTask
    NSMutableDictionary* postDictionary = [NSMutableDictionary dictionary];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld", self.serviceInfo.upId] forKey:@"upId"];
    UserInfo* curUser = [UserInfoHelper defaultHelper].currentUserInfo;
    [postDictionary setValue:[NSString stringWithFormat:@"%ld", curUser.userId] forKey:@"recommendUserId"];
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"ShareProductTask" taskParam:postDictionary TaskObserver:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(44, 17.5, 57, 17.5));
    }];
}

#pragma mark settingAndGetting
- (ServiceQRCodeView*) qrCodeView
{
    if (!_qrCodeView) {
        _qrCodeView = [[ServiceQRCodeView alloc] init];
        [self.view addSubview:_qrCodeView];
        _qrCodeView.layer.cornerRadius = 3;
        _qrCodeView.layer.masksToBounds = YES;
    }
    
    return _qrCodeView;
}

- (void) closeController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (errorMessage != StepError_None) {
        __weak typeof(self) weakSelf = self;
        [self showAlertMessage:errorMessage clicked:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
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
    
    if ([taskname isEqualToString:@"ShareProductTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSString class]]) {
            NSString* shareUrl = (NSString*) taskResult;
            [self.qrCodeView setShareUrl:shareUrl];
        }
    }
    
}

@end
