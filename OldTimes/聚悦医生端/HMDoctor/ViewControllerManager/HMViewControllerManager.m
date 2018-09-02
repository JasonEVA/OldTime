//
//  HMViewControllerManager.m
//  HMDoctor
//
//  Created by yinquan on 16/4/9.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMViewControllerManager.h"
#import "HMBaseNavigationViewController.h"
#import "MainStartTabbarViewController.h"
#import "InitializeViewController.h"
#import "UserLoginViewController.h"
#import <MintcodeIMKit/MessageManager.h>
#import "ChatIMConfigure.h"
#import "AppDelegate.h"
#import "IMMessageHandlingCenter.h"
#import "DAOFactory.h"
#import "ATLog.h"

static HMViewControllerManager* defaultViewControllerManager = nil;

@implementation HMViewControllerManager

+ (HMViewControllerManager*) defaultManager
{
    if (!defaultViewControllerManager)
    {
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

+ (UIViewController*) topMostNavigationController
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *topMostViewController = keyWindow.rootViewController;
    
    UIViewController* upperViewController = [self upperNavigationController:topMostViewController];
    while ((upperViewController.navigationController || [upperViewController isKindOfClass:[UINavigationController class]]) && topMostViewController != upperViewController) {
        topMostViewController = upperViewController;
        upperViewController = [self upperNavigationController:upperViewController];
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

+ (UIViewController*) upperNavigationController:(UIViewController*) viewController
{
    UIViewController* upperViewController = viewController;
    while (upperViewController.presentedViewController) {
        
        UIViewController* presentedViewController = upperViewController.presentedViewController;
        UIViewController* upperNavigationController = [self upperNavigationController:presentedViewController];
        if (upperViewController.navigationController && [upperViewController isKindOfClass:[UINavigationController class]]) {
            upperViewController = upperNavigationController;
        }
        else
        {
            break;
        }
    };
    
    if ([upperViewController isKindOfClass:[UINavigationController class]]) {
        upperViewController = [(UINavigationController *)upperViewController visibleViewController];
    } else if ([upperViewController isKindOfClass:[UITabBarController class]]) {
        upperViewController = [(UITabBarController *)upperViewController selectedViewController];
    }
    
    return upperViewController;
}

- (void) entryMainStart
{
    if (!_tabRoot)
    {
        _tabRoot = [[MainStartTabbarViewController alloc]init];
    }
    else
    {
        [_tabRoot setSelectedIndex:0];
    }
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [app.window setRootViewController:_tabRoot];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    UserInfo* user = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    // 上传日志
//    [ATLog uploadLogFile];
    
    // 登录IM
    if (!user) {
        return;
    }
    // 获取病人列表
    [_DAO.patientInfoListDAO requestPatientList];

    // 配置IM通知
    [[IMMessageHandlingCenter sharedInstance] addIMNotifications];

    [MessageManager setUserId:[NSString stringWithFormat:@"%ld", user.userId] nickName:staff.staffName];
    [[MessageManager share] login];
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@-%ld",SESESSIONTYPELIST,user.userId]]) {
        [[NSUserDefaults standardUserDefaults] setValue:@[@(0),@(1),@(2),@(3),@(4),@(5)] forKey:[NSString stringWithFormat:@"%@-%ld",SESESSIONTYPELIST,user.userId]];
    }
    if (![[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@-%ld",SESESSIONTYPEVIEWISSHOWHEAD,user.userId]]) {
        [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:[NSString stringWithFormat:@"%@-%ld",SESESSIONTYPEVIEWISSHOWHEAD,user.userId]];
    }
    

    if ([RemoteNoticationHelper defaultHelper].notificationControllerName ||
        [RemoteNoticationHelper defaultHelper].routerURLString)
    {
        //接收到推送消息，需要跳转
        [self performSelector:@selector(gotoNotificationController) withObject:nil afterDelay:0.5];
        
    }
}

- (void) gotoNotificationController
{
    [[RemoteNoticationHelper defaultHelper] gotoNotificationController];
}

//返回App首页
- (void) popToHomePage
{
    if (!_tabRoot ) {
        return;
    }
    [_tabRoot setSelectedIndex:0];
    for (HMBaseNavigationViewController* nvc in _tabRoot.viewControllers)
    {
        [nvc popToRootViewControllerAnimated:YES];
    }
    //[_navRoot popToRootViewControllerAnimated:NO];
}
- (void) userLogout
{
    [[UserInfoHelper defaultHelper] userlogout];
    [[MessageManager share] logout];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // 清除图片缓存
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [self startUserLogin];
}


- (void) startUserLogin
{
    UserLoginViewController* vcLogin = [[UserLoginViewController alloc]initWithNibName:nil bundle:nil];
    UINavigationController* nvcLogin = [[HMBaseNavigationViewController alloc]initWithRootViewController:vcLogin];
    if (_tabRoot)
    {
        _tabRoot = nil;
    }
    
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.window setRootViewController:nvcLogin];

//    [_tabRoot addChildViewController:vcLogin];
//    [_tabRoot.view addSubview:vcLogin.view];
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
    if (!dicController || ![dicController isKindOfClass:[NSDictionary class]]) {
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
    if (!dicController || [dicController isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    id object = [dicController valueForKey:@"controllerObject"];
    if (object)
    {
        return object;
    }
    return nil;
}

+ (HMBasePageViewController*) entryPageViewController:(HMBasePageViewController*) pageViewController
{
    UIViewController* topMostViewController = [self topMostController];
    
    UINavigationController* selectedNavigationContoller = topMostViewController.navigationController;
    if (!selectedNavigationContoller) {
        return nil;
    }
    if (![selectedNavigationContoller isKindOfClass:[UINavigationController class]])
    {
        return nil;
    }
    
    NSArray* pageContorllers = [selectedNavigationContoller viewControllers];
    __block HMBasePageViewController* existedPageViewController = nil;
    
    [pageContorllers enumerateObjectsUsingBlock:^(UIViewController* viewController, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([viewController isKindOfClass:[HMBasePageViewController class]])
        {
            HMBasePageViewController* pageController = (HMBasePageViewController*) viewController;
            if (!pageController.controllerId || pageController.controllerId.length == 0) {
                return ;
            }
            
            if ([pageController.controllerId isEqualToString:pageViewController.controllerId]) {
                existedPageViewController = pageController;
                
                
                *stop = YES;
                return;
            }
        }
    }];
    
    if (existedPageViewController) {
        [selectedNavigationContoller popToViewController:existedPageViewController animated:YES];
        return existedPageViewController;
    }
    
    [selectedNavigationContoller pushViewController:pageViewController animated:YES];
    
    return pageViewController;
}


+ (HMBasePageViewController*) createViewControllerWithControllerName:(NSString*) controllerName
                                                    ControllerObject:(id) controllerObject
{
    UIViewController* topViewController = [self topMostNavigationController];

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
    
    [nvcTop pushViewController:vcPage animated:YES];
    return vcPage;
}

+ (HMBasePageViewController*) createViewControllerWithControllerName:(NSString*) controllerName
                                                    FromControllerId:(NSString*) perControllerId
                                                    ControllerObject:(id) controllerObject
{
    UIViewController* topViewController = [self topMostController];
    if (!topViewController || ![topViewController isKindOfClass:[UINavigationController class]])
    {
        return nil;
    }
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

