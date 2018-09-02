//
//  ServiceShareViewController.m
//  HMClient
//
//  Created by yinquan on 2017/5/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "ServiceShareViewController.h"
#import "ServiceQRCodeViewController.h"
#import "HMBaseNavigationViewController.h"

@interface ServiceShareButton : UIButton


@end

@implementation ServiceShareButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect imageRect = CGRectMake((contentRect.size.width - 68)/2, 3, 68, 68);
    return imageRect;
}

- (CGRect) titleRectForContentRect:(CGRect)contentRect
{
    CGRect titleRect = CGRectMake(2.5, 87, contentRect.size.width - 5, 24);
    return titleRect;
}

@end

@interface ServiceShareView : UIView

@property (nonatomic, readonly) UILabel* titleLable;
@property (nonatomic, readonly) UIView* buttonsView;
@property (nonatomic, readonly) NSArray* shareButtons;

@end

@implementation ServiceShareView

@synthesize titleLable = _titleLable;
@synthesize buttonsView = _buttonsView;
@synthesize shareButtons = _shareButtons;

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
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(20);
    }];
    
    [self.buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat offset = ((kScreenWidth - 36)/4 - 64)/2;
        make.left.equalTo(self).with.offset(offset);
        make.right.equalTo(self).with.offset(-offset);
        make.top.equalTo(self).with.offset(69);
        make.bottom.equalTo(self);
    }];
    
    __block MASViewAttribute* buttonLeft = self.buttonsView.mas_left;
    
    [self.shareButtons enumerateObjectsUsingBlock:^(ServiceShareButton* button, NSUInteger idx, BOOL * _Nonnull stop)
    {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.buttonsView);
            if (button == self.shareButtons.lastObject) {
                make.right.equalTo(self.buttonsView);
            }
            make.left.equalTo(buttonLeft);
            
            if (idx > 0) {
                UIButton* preButton = self.shareButtons[idx - 1];
                make.width.equalTo(preButton);
            }
            
            buttonLeft = button.mas_right;
        }];
    }];
}

#pragma mark - settingAndGetting

- (UILabel*) titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        [self addSubview:_titleLable];
        [_titleLable setText:@"分享"];
        [_titleLable setTextColor:[UIColor commonTextColor]];
        [_titleLable setFont:[UIFont systemFontOfSize:15]];
    }
    return _titleLable;
}

- (UIView*) buttonsView
{
    if (!_buttonsView) {
        _buttonsView = [[UIView alloc] init];
        [self addSubview:_buttonsView];
        [_buttonsView setBackgroundColor:[UIColor whiteColor]];
    }
    return _buttonsView;
}

- (NSArray*) shareButtons
{
    if (!_shareButtons) {
        NSArray* titles = @[@"微信好友", @"朋友圈", @"生成二维码", @"复制链接"];
        NSArray* imageNames = @[@"service_share_session", @"service_share_timeline", @"service_share_qrcode", @"service_share_copylink"];
        
        NSMutableArray* shareButtons = [NSMutableArray array];
        [titles enumerateObjectsUsingBlock:^(NSString* title, NSUInteger idx, BOOL * _Nonnull stop) {
            ServiceShareButton* button = [ServiceShareButton buttonWithType:UIButtonTypeCustom];
            [shareButtons addObject:button];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setImage:[UIImage imageNamed:imageNames[idx] ] forState:UIControlStateNormal];
            [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [self.buttonsView addSubview:button];
        }];
        
        _shareButtons = shareButtons;
    }
    
    return _shareButtons;
    
}

@end

typedef NS_ENUM(NSUInteger, ServiceShareIndex) {
    ServiceShare_Session,
    ServiceShare_TimeLine,
    
    ServiceShare_QRCode,
    ServiceShare_CopyLine,
};

#import "WXApi.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

@interface ServiceShareViewController ()
<TaskObserver>

@property (nonatomic, readonly) ServiceInfo* serviceInfo;
@property (nonatomic, readonly) ServiceShareView* shareView;
@property (nonatomic, readonly) NSString* shareURL;

- (id) initWithServiceInfo:(ServiceInfo*) serviceInfo;
@end


@implementation ServiceShareViewController

@synthesize serviceInfo = _serviceInfo;
@synthesize shareView = _shareView;

+ (void) showInParentController:(UIViewController*) parentController
                    ServiceInfo:(ServiceInfo*) serviceInfo
{
    if (!parentController) {
        return;
    }
    if (!serviceInfo) {
        return;
    }
    ServiceShareViewController* shareViewController = [[ServiceShareViewController alloc] initWithServiceInfo:serviceInfo];
    [parentController addChildViewController:shareViewController];
    [parentController.view addSubview:shareViewController.view];
    [shareViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(parentController.view);
    }];
}


- (id) initWithServiceInfo:(ServiceInfo*) serviceInfo
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _serviceInfo = serviceInfo;
    }
    return self;
}

- (void) loadView
{
    UIControl* closeControl = [[UIControl alloc] init];
    [self setView:closeControl];
    [closeControl addTarget:self action:@selector(closeControl) forControlEvents:UIControlEventAllTouchEvents];
    [closeControl setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.shareView.shareButtons enumerateObjectsUsingBlock:^(ServiceShareButton* button, NSUInteger idx, BOOL * _Nonnull stop) {
        [button addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
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
    
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@200);
    }];
}

- (void) closeControl
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void) shareButtonClicked:(id) sender
{
    NSInteger clickedIndex = [self.shareView.shareButtons indexOfObject:sender];
    if (clickedIndex == NSNotFound) {
        return;
    }
    
    switch (clickedIndex)
    {
        case ServiceShare_Session:
        {
            //分享给好友
            [self shareInWeiChat:SSDKPlatformSubTypeWechatSession];
            break;
        }
        case ServiceShare_TimeLine:
        {
            //分享到朋友圈
            [self shareInWeiChat:SSDKPlatformSubTypeWechatTimeline];
            break;
        }
        
        case ServiceShare_QRCode:
        {
            //生成二维码
            [self showQRCodeViewController];
            break;
        }
        case ServiceShare_CopyLine:
        {
            //复制链接
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.shareURL;
            [self showAlertMessage:@"复制成功。"];
            [self closeControl];
            break;
        }
        
    }
}

- (void) shareInWeiChat:(SSDKPlatformType) platformType
{
    //分享内容
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSString* imgUrl = self.serviceInfo.imgUrl;
    NSArray* imageArray = @[[UIImage imageNamed:@"icon_h"]];
    if (imgUrl) {
        imageArray = @[imgUrl];
    }
    
    NSString* webUrl = self.shareURL;
    
    [shareParams SSDKSetupShareParamsByText:self.serviceInfo.desc
                                     images:imageArray
                                        url:[NSURL URLWithString:webUrl]
                                      title:self.serviceInfo.productName
                                       type:SSDKContentTypeWebPage];
    
    
    //进行分享
    [ShareSDK share:platformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state)
        {
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:[NSString stringWithFormat:@"%@",@"分享失败"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            default:
                break;
        }

    }];
    
    /*
    [ShareSDK showShareActionSheet:nil
                             items:@[@(platformType)]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   switch (state)
                   {
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                           message:[NSString stringWithFormat:@"%@",@"分享失败"]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                        default:
                           break;
                   }
                   
               }];
    */
    
}

- (void) showQRCodeViewController
{
    ServiceQRCodeViewController* qrCodeViewController = [[ServiceQRCodeViewController alloc] initWithServiceInfo:self.serviceInfo shareUrl:self.shareURL];
    UINavigationController* qrCodeNavigationContoller = [[HMBaseNavigationViewController alloc] initWithRootViewController:qrCodeViewController];
    
    [self.navigationController presentViewController:qrCodeNavigationContoller animated:YES completion:nil];
}


#pragma mark - settingAndGetting
- (ServiceShareView*) shareView
{
    if (!_shareView) {
        _shareView = [[ServiceShareView alloc] init];
        [self.view addSubview:_shareView];
        
        
    }
    return _shareView;
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (errorMessage != StepError_None) {
        [self showAlertMessage:errorMessage clicked:^{
            [self closeControl];
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
            _shareURL = (NSString*) taskResult;
        }
    }
    
}
@end
