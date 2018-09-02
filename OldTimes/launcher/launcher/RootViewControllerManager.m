//
//  RootViewControllerManager.m
//  launcher
//
//  Created by William Zhang on 15/7/24.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "RootViewControllerManager.h"
#import "BaseNavigationController.h"
#import "CompanySelectViewController.h"
#import "PasswordLoginViewController.h"
#import "GraphicLoginViewController.h"
#import "GraphicSetViewController.h"
#import "HomeTabBarController.h"
#import "UnifiedUserInfoManager.h"
#import "UnifiedLoginManager.h"
#import <MintcodeIM/MintcodeIM.h>
#import "SettingModel.h"
#import "JapanPasswordLoginViewController.h"
#import "JapanCompanySelectViewController.h"

@interface RootViewControllerManager ()

@property (nonatomic, strong)UIWindow *keyWindow;

#if defined(JAPANMODE) || defined(JAPANTESTMODE)
@property (nonatomic, strong) JapanPasswordLoginViewController *pwdLoginVC;
#else
@property (nonatomic, strong) PasswordLoginViewController *pwdLoginVC;
#endif
@property (nonatomic, strong) GraphicLoginViewController  *graphicLoginVC;
@property (nonatomic, strong) HomeTabBarController        *homeVC;
@property (nonatomic, strong) BaseNavigationController    *graphicSetNVC;
@property (nonatomic, strong) BaseNavigationController    *companySelectNVC;

@property (nonatomic, strong) UIScrollView *scrollViewGuide;

@end

@implementation RootViewControllerManager

- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super init];
    if (self) {
        self.keyWindow = window;
    }
    return self;
}

- (void)loginWays
{
    NSString *loginName = [[UnifiedUserInfoManager share] getAccountWithEncrypt:YES];
    SettingModel *settingModel = [[UnifiedLoginManager share] findDataModelWithLoginName:loginName];
	[[UnifiedUserInfoManager share] verifyMTVersion];
	
    BOOL isLogin;
    NSString *strPassword;
    if (settingModel)
    {
        isLogin = [settingModel.isLogin boolValue];
        strPassword = settingModel.graphicPassword;
    }
    
    if (isLogin && strPassword.length)
    {
        [self showGraphicLogin];
    } else {
        [self showPasswordLogin];
    }
    
    BOOL isNewVersion = [[UnifiedUserInfoManager share] isNewVersionIsSubVersion:YES];
    if (isNewVersion) {
        [self showGuidePage];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:MTWilShowFingerPrintNotification object:nil];
    }
}

- (void)showPasswordLoginViewForValid {
    [self showPasswordLogin];
    [self.pwdLoginVC showValidHUD];
}

- (void)showPasswordLogin
{
    if (!self.pwdLoginVC) {
#if defined(JAPANMODE) || defined(JAPANTESTMODE)
        self.pwdLoginVC = [[JapanPasswordLoginViewController alloc] init];
#else
        self.pwdLoginVC = [[PasswordLoginViewController alloc] init];
#endif
    }
    
    if (self.graphicLoginVC) {
        self.graphicLoginVC = nil;
    }
    
    if (self.graphicSetNVC) {
        self.graphicSetNVC = nil;
    }
    
    self.keyWindow.rootViewController = self.pwdLoginVC;
}

- (void)showGraphicLogin
{
    if (!_graphicLoginVC) {
        _graphicLoginVC = [[GraphicLoginViewController alloc] init];
        [_graphicLoginVC setNotify];
    }
    
    if (self.pwdLoginVC) {
        self.pwdLoginVC = nil;
    }
    self.keyWindow.rootViewController = self.graphicLoginVC;
}

- (void)showGraphicSetting
{
    if (!self.graphicSetNVC) {
        GraphicSetViewController *graphicSetVC = [[GraphicSetViewController alloc] init];
        self.graphicSetNVC = [[BaseNavigationController alloc] initWithRootViewController:graphicSetVC];
    }
    
    if (self.pwdLoginVC) {
        self.pwdLoginVC = nil;
    }
    self.keyWindow.rootViewController = self.graphicSetNVC;
}

- (void)showCompany {
    if (!self.companySelectNVC) {
#if defined(JAPANMODE) || defined(JAPANTESTMODE)
        self.companySelectNVC = [[JapanNaviCompanySelectViewController alloc] initWithChangeCompany:NO];
#else
        CompanySelectViewController *companySelectVC = [[CompanySelectViewController alloc] initWithChangeCompany:NO];
        self.companySelectNVC = [[BaseNavigationController alloc] initWithRootViewController:companySelectVC];
#endif
    }
    
    if (self.pwdLoginVC) {
        self.pwdLoginVC = nil;
    }
    
    if (self.graphicSetNVC) {
        self.graphicSetNVC = nil;
    }
    
    self.keyWindow.rootViewController = self.companySelectNVC;
}

- (void)showHome
{
    if (!self.homeVC)
    {
        self.homeVC = [[HomeTabBarController alloc] init];
    }
    
    //手动清除原先创建的VC
    if (self.pwdLoginVC){self.pwdLoginVC = nil;}
    if (self.graphicLoginVC){self.graphicLoginVC = nil;}
    if (self.companySelectNVC){self.companySelectNVC = nil;}
    
    
    // 先让ChatViewController加载会数据
    [self.keyWindow performSelector:@selector(setRootViewController:) withObject:self.homeVC afterDelay:0.0];
}

- (void)dissGestureVerify
{
    [self.graphicLoginVC dismissViewControllerAnimated:YES completion:^{
        // 正在连接中
        [[NSNotificationCenter defaultCenter] postNotificationName:MTSocketConnectingNotification object:nil];
        
        // 获取未读会话消息 涉及设备切换之后同步
        [[MessageManager share] getMessageList];
        
        // 重连socket
//        [[MessageManager share] getOfflineMessage];
        
    }];
}

- (void)releaseHomeView {
    NSString *secretLoginName = [[UnifiedUserInfoManager share] getAccountWithEncrypt:YES];
    SettingModel *settingModel = [[UnifiedLoginManager share] findDataModelWithLoginName:secretLoginName];
    if (settingModel) {
        settingModel.isLogin = @NO;
        settingModel.graphicPassword = @"";
        [[UnifiedLoginManager share] insertData:settingModel];
    }
    // 清除用户信息
    [[UnifiedUserInfoManager share] removeUserInfo];
    
    // 移除homeview
    if (self.homeVC)
    {
        [self.homeVC.view removeFromSuperview];
        [self.homeVC removeFromParentViewController];
        self.homeVC = nil;
    }
    // 跳转到密码登录页
    [self showPasswordLogin];
}

- (void)changeStatus {
    self.homeVC = nil;
    [self showHome];
    [self.homeVC setSelectedIndex:3];
}

- (BOOL)isLogin {
    NSString *loginName = [[UnifiedUserInfoManager share] getAccountWithEncrypt:YES];
    SettingModel *settingModel = [[UnifiedLoginManager share] findDataModelWithLoginName:loginName];
    BOOL isLogin;
    NSString *strPassword;
    if (settingModel)
    {
        isLogin = [settingModel.isLogin boolValue];
        strPassword = settingModel.graphicPassword;
    }
    
    if (isLogin && strPassword.length)
    {
        [self showGraphicLogin];
        return YES;
    }
    
    return NO;
}

#pragma mark - 3DTouch Event
- (void)beginQRCode
{
    if ([self isLogin])
    {
        [self showHome];
        
        __weak typeof(self) weakSelf = self;
        [CATransaction begin];
        [[NSNotificationCenter defaultCenter] postNotificationName:MTWillJumpTabbarToSubItemNotification object:@3];
        [CATransaction setCompletionBlock:^{
        [weakSelf performSelector:@selector(QRCode) withObject:nil afterDelay:1.0];
        }];
        [CATransaction commit];
    }
}

- (void)beginChat
{
    if ([self isLogin])
    {
        [self showHome];
        
        [CATransaction begin];
        [[NSNotificationCenter defaultCenter] postNotificationName:MTWillJumpTabbarToSubItemNotification object:@0];
        [CATransaction setCompletionBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MTWillCreateGroupNotification object:nil];
        }];
        [CATransaction commit];
    }
    else
    {

        [self.graphicLoginVC setDismissBlock:^{
            [CATransaction begin];
            [[NSNotificationCenter defaultCenter] postNotificationName:MTWillJumpTabbarToSubItemNotification object:@0];
            [CATransaction setCompletionBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:MTWillCreateGroupNotification object:nil];
            }];
            [CATransaction commit];
        }];
    }
}

- (void)beginSearch
{
    if ([self isLogin])
    {
        [self showHome];
    
        [CATransaction begin];
        [[NSNotificationCenter defaultCenter] postNotificationName:MTWillJumpTabbarToSubItemNotification object:@0];
        [CATransaction setCompletionBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:MTWillBeginSearchContentNotification object:nil];
        }];
        [CATransaction commit];
    }
}

- (void)beginNewCalendar
{
    if ([self isLogin])
    {
        [self showHome];
        
        __weak typeof(self) weakSelf = self;
        [CATransaction begin];
        [[NSNotificationCenter defaultCenter] postNotificationName:MTWillJumpTabbarToSubItemNotification object:@2];
        [CATransaction setCompletionBlock:^{
            [weakSelf performSelector:@selector(Calendar) withObject:nil afterDelay:1.0];
        }];
        [CATransaction commit];
    }
}

- (void)QRCode
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MTWillBeginScanQCCodeNotification object:nil];
}

- (void)Calendar
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MTWillBeginSkimCalendarNotification object:nil];
}

#pragma mark - GuideImage
- (void)showGuidePage {
    self.scrollViewGuide = [[UIScrollView alloc] initWithFrame:self.keyWindow.bounds];
    [self.scrollViewGuide setBounces:NO];
    [self.scrollViewGuide setPagingEnabled:YES];
    [self.scrollViewGuide setShowsHorizontalScrollIndicator:NO];
    [self.scrollViewGuide setShowsVerticalScrollIndicator:NO];
    
    NSArray *arrayImage = [self arrayGuideImage];
    if (![arrayImage count]) {
        self.scrollViewGuide = nil;
        return;
    }
    
    [self.scrollViewGuide setContentSize:CGSizeMake(CGRectGetWidth(self.scrollViewGuide.frame) * [arrayImage count], 0)];
    for (NSInteger i = 0; i < [arrayImage count]; i ++) {
        UIImage *image = [arrayImage objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        CGRect frame = self.scrollViewGuide.bounds;
        frame.origin.x = CGRectGetWidth(frame) * i;
        imageView.frame = frame;
        [self.scrollViewGuide addSubview:imageView];
        
        if (i == [arrayImage count] - 1) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeGuideImage)];
            [imageView addGestureRecognizer:tapGesture];
            [imageView setUserInteractionEnabled:YES];
        }
    }

    if (self.pwdLoginVC) {
        [self.pwdLoginVC.view addSubview:self.scrollViewGuide];
    } else {
        [self.graphicLoginVC.view addSubview:self.scrollViewGuide];
    }
}

- (void)removeGuideImage {
    [UIView animateWithDuration:1.5 animations:^{
        self.scrollViewGuide.alpha = 0;
    } completion:^(BOOL finished) {
        [self.scrollViewGuide removeFromSuperview];
        self.scrollViewGuide = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:MTWilShowFingerPrintNotification object:nil];
    }];
}

- (NSArray *)arrayGuideImage {
    NSString *strName = [@"guideImage" stringByAppendingString:(IOS_DEVICE_4 ? @"Small" : @"Big")];
    if ([UnifiedUserInfoManager share].isMTVersion) {
        strName = [strName stringByAppendingString:@"_China"];
    }
	
	NSMutableArray *arrayImage = [NSMutableArray array];
    
    for (NSInteger i = 1;; i ++) {
        NSString *imageName = [strName stringByAppendingFormat:@"_%ld", (long)i];
        UIImage *image = [UIImage imageNamed:imageName];
        if (!image) {
            break;
        }
        
        [arrayImage addObject:image];
    }
    
    return arrayImage;
}

@end
