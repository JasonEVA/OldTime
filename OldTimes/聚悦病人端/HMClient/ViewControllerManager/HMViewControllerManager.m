//
//  HMViewControllerManager.m
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMViewControllerManager.h"
#import "AppDelegate.h"
#import "HMBasePageViewController.h"
//#import "InitializeViewController.h"
#import "InitializationHelper.h"
#import "UserLoginViewController.h"
#import "HMBaseNavigationViewController.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "IMMessageHandlingCenter.h"

static HMViewControllerManager* defaultViewControllerManager = nil;


@implementation HMViewControllerManager

+ (HMViewControllerManager*) defaultManager
{
    if (!defaultViewControllerManager) {
        defaultViewControllerManager = [[HMViewControllerManager alloc]init];
    }
    return defaultViewControllerManager;
}

+ (UIViewController*) topMostController
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *topMostViewController = keyWindow.rootViewController;

    UIViewController* upperViewController = [self upperViewController:topMostViewController];
    while (topMostViewController != upperViewController) {
        topMostViewController = upperViewController;
        upperViewController = [self upperViewController:upperViewController];
    }

    return topMostViewController;
}

+ (UIViewController*) upperViewController:(UIViewController*) viewController
{
    UIViewController* upperViewController = viewController;
    while (upperViewController.presentedViewController) {
        upperViewController = upperViewController.presentedViewController;
    };
    
    if ([upperViewController isKindOfClass:[UINavigationController class]]) {
        upperViewController = [(UINavigationController *)upperViewController visibleViewController];
    } else if ([upperViewController isKindOfClass:[UITabBarController class]]) {
        upperViewController = [(UITabBarController *)upperViewController selectedViewController];
    }
    
    return upperViewController;
}

+ (UIViewController*) topMostNavigationController
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *topMostViewController = keyWindow.rootViewController;
    
    UIViewController* upperViewController = [self upperViewController:topMostViewController];
    
    while (upperViewController.navigationController && topMostViewController != upperViewController) {
        topMostViewController = upperViewController;
        upperViewController = [self upperViewController:upperViewController];
    }
    
    return topMostViewController;
}




- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id) init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogined) name:kUserLoginSuccessNotificationName object:nil];
        
        
    }
    
    
    return self;
    
    
}

- (void) entryMainPage
{
    if (!_tvcRoot)
    {
        _tvcRoot = [[MainStartTabbarViewController alloc]initWithNibName:nil bundle:nil];

    }
    else
    {
        [_tvcRoot setSelectedIndex:0];
    }
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.window setRootViewController:_tvcRoot];

    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    if (curUser) {
        // 配置IM通知
        [[IMMessageHandlingCenter sharedInstance] addIMNotifications];
        [MessageManager setUserId:[NSString stringWithFormat:@"%ld", curUser.userId] nickName:curUser.userName];
        [[MessageManager share] login];
    }

    
//
    if ([RemoteNoticationHelper defaultHelper].notificationControllerName ||
        [RemoteNoticationHelper defaultHelper].routerURLString)
    {
        //接收到推送消息，需要跳转
        [self performSelector:@selector(gotoNotificationController) withObject:nil afterDelay:0.5];
        
    }
}

- (void) startUserLogin
{
    UserLoginViewController* vcLogin = [[UserLoginViewController alloc]initWithNibName:nil bundle:nil];
    UINavigationController* nvcLogin = [[HMBaseNavigationViewController alloc]initWithRootViewController:vcLogin];
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.window setRootViewController:nvcLogin];
    
    //    [_tabRoot addChildViewController:vcLogin];
    //    [_tabRoot.view addSubview:vcLogin.view];
}

- (void) gotoNotificationController
{
    [[RemoteNoticationHelper defaultHelper] gotoNotificationController];
}

- (void) entryUserLoginPage
{
    UserLoginViewController* vcLogin = [[UserLoginViewController alloc]initWithNibName:nil bundle:nil];
    UINavigationController* nvcLogin = [[HMBaseNavigationViewController alloc]initWithRootViewController:vcLogin];
    
    if (_tvcRoot)
    {
        _tvcRoot = nil;
    }
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.window setRootViewController:nvcLogin];
}

- (void) userLogined
{
    NSLog(@"MainStartViewController::userLogined ... ");
    //[self entryMainPage];
    [[InitializationHelper defaultHelper] startInitialize];
}

- (void) userLogout
{
    [[UserInfoHelper defaultHelper] userlogout];
    [[MessageManager share] logout];
    // 清除图片缓存
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    [self entryUserLoginPage];
}

+ (NSString*) controllerIdWithControllerName:(NSString*) controllerName
                            ControllerObject:(NSObject*) controllerObject
{
    if (!controllerName || 0 == controllerName.length) {
        return nil;
    }
    NSMutableDictionary* dicController = [NSMutableDictionary dictionary];
    [dicController setValue:controllerName forKey:@"controllerName"];
    if (controllerObject)
    {
        if ([controllerObject isKindOfClass:[NSArray class]])
        {
            NSArray* lstObject = [NSObject mj_keyValuesArrayWithObjectArray:(NSArray*)controllerObject];
            [dicController setValue:lstObject forKey:@"controllerObject"];
        }
        else
        {
            NSDictionary* dicObject = [controllerObject mj_keyValues];
            [dicController setValue:dicObject forKey:@"controllerObject"];
        }
        
    }
    
    NSString* controllerId = [dicController mj_JSONString];
    return controllerId;
}

+ (NSString*) controllerNameWithControllerId:(NSString*) controllerId
{
    NSDictionary* dicController = (NSDictionary*)[controllerId mj_JSONObject];
    if (!dicController || [dicController isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSString* controllerName = [dicController valueForKey:@"controllerName"];
    if (controllerName && [controllerName isKindOfClass:[NSString class]])
    {
        return controllerName;
    }
    return nil;
}

+ (id) controllerObjectithControllerId:(NSString*) controllerId
{
    NSDictionary* dicController = (NSDictionary*)[controllerId mj_JSONObject];
    if (!dicController || ![dicController isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    id object = [dicController valueForKey:@"controllerObject"];
    if (object)
    {
        return object;
    }
    return nil;
}

+ (HMBasePageViewController*) createViewControllerWithControllerName:(NSString*) controllerName
                                                    ControllerObject:(id) controllerObject
{
    UIViewController* topViewController = [self topMostController];
//    if (!topViewController || ![topViewController isKindOfClass:[UINavigationController class]])
//    {
//        if (![HMViewControllerManager defaultManager].tvcRoot) {
//            [[HMViewControllerManager defaultManager] entryMainPage];
//        }
////        return nil;
//        
//    }
    if (!topViewController) {
        return nil;
    }
    if (![topViewController isKindOfClass:[UINavigationController class]])
    {
        topViewController = topViewController.navigationController;
        if (![topViewController isKindOfClass:[UINavigationController class]])
        {
            return nil;
        }
        
    }
    
    NSString* controllerId = [self controllerIdWithControllerName:controllerName ControllerObject:controllerObject];
    if (!controllerId)
    {
        return nil;
    }
    
    UINavigationController* nvcTop = (UINavigationController*) topViewController;
    NSArray* vcList = nvcTop.viewControllers;
    for (UIViewController* existedVC in vcList)
    {
        if ([existedVC isKindOfClass:[HMBasePageViewController class]])
        {
            HMBasePageViewController* vcExistedPage = (HMBasePageViewController*)existedVC;
            if ([vcExistedPage.controllerId isEqualToString:controllerId])
            {
                [nvcTop popToViewController:vcExistedPage animated:YES];
                return vcExistedPage;
            }
        }
    }
    
    HMBasePageViewController* vcPage = [[NSClassFromString(controllerName) alloc]initWithControllerId:controllerId];
    [vcPage setParamObject:controllerObject];
    vcPage.edgesForExtendedLayout = UIRectEdgeNone;

    [nvcTop pushViewController:vcPage animated:YES];
    return vcPage;
}

+ (HMBasePageViewController*) createViewControllerWithControllerName:(NSString*) controllerName
                                                  FromControllerId:(NSString*) perControllerId
                                                    ControllerObject:(id) controllerObject
{
    UIViewController* topViewController = [self topMostController];
    if (!topViewController) {
        return nil;
    }
    if (![topViewController isKindOfClass:[UINavigationController class]]) {
        topViewController = topViewController.navigationController;
        if (!topViewController) {
            return nil;
        }
    }
//    if (!topViewController || ![topViewController isKindOfClass:[UINavigationController class]])
//    {
//        return nil;
//    }
    UINavigationController* nvcTop = (UINavigationController*) topViewController;
    if (!perControllerId)
    {
        [nvcTop popViewControllerAnimated:NO];
    }
    
    NSArray* vcList = nvcTop.viewControllers;
    for (UIViewController* existedVC in vcList)
    {
        if ([existedVC isKindOfClass:[HMBasePageViewController class]])
        {
            HMBasePageViewController* vcExistedPage = (HMBasePageViewController*)existedVC;
            if ([vcExistedPage.controllerId isEqualToString:perControllerId])
            {
                [nvcTop popToViewController:vcExistedPage animated:NO];
                
            }
        }

    }
    
    
    NSString* controllerId = [self controllerIdWithControllerName:controllerName ControllerObject:controllerObject];
    if (!controllerId)
    {
        return nil;
    }
    
    for (UIViewController* existedVC in vcList)
    {
        if ([existedVC isKindOfClass:[HMBasePageViewController class]])
        {
            HMBasePageViewController* vcExistedPage = (HMBasePageViewController*)existedVC;
            if ([vcExistedPage.controllerId isEqualToString:controllerId])
            {
                [nvcTop popToViewController:vcExistedPage animated:YES];
                return vcExistedPage;
            }
        }
    }
    
    HMBasePageViewController* vcPage = [[NSClassFromString(controllerName) alloc]initWithControllerId:controllerId];
    [vcPage setParamObject:controllerObject];
    [nvcTop pushViewController:vcPage animated:YES];
    return vcPage;
}
@end
