//
//  AppDelegate.m
//  HMDoctor
//
//  Created by yinquan on 16/4/9.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AppDelegate.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "ChatIMConfigure.h"
#import "IMApplicationConfigure.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "MainGuideStartViewController.h"
#import "ActionStatusManager.h"
#import "InitializeViewController.h"
#import "CommonEncrypt.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface AppDelegate ()
{
    BOOL canGotoNotification;
}
@property float autoSizeScaleX;

@property float autoSizeScaleY;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 打开日志系统
//    [ATLog configLogEnable:YES];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Launch Screen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    UIWindow *mainWindow = self.window;
    [mainWindow setRootViewController:viewController];
    
    //配置友盟
    [self configUMSDK];
    
    //[[HMViewControllerManager defaultManager] entryInitView];
    [self getIOSDeviceToken];
    
    // 配置IM
    [self configIMSettings];
    
    // 配置一些组件
    [self conifgThirdLib];
    
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        canGotoNotification = NO;
        // 有推送的消息，处理推送的消息
        NSString* alertUrlStr = userInfo[@"alertUrl"];
        NSDictionary* dicAlertUrl = nil;
        if (alertUrlStr && [alertUrlStr isKindOfClass:[NSString class]])
        {
            dicAlertUrl = [NSDictionary JSONValue:alertUrlStr];
        }
        if (dicAlertUrl && [dicAlertUrl isKindOfClass:[NSDictionary class]])
        {
            [[RemoteNoticationHelper defaultHelper] setAlertInfo:dicAlertUrl];
        }
        
    }
    
//    if (@available(iOS 11, *)) {
//        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPEnterBackground" object:self];

    canGotoNotification = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // 判断是否登录，登录则重连
    UserInfo* user = [[UserInfoHelper defaultHelper] currentUserInfo];
    // 重连IM
    if (!user) {
        return;
    }
    // 上传日志
//    [ATLog uploadLogFile];

    // 连接中
    [[NSNotificationCenter defaultCenter] postNotificationName:MTSocketConnectingNotification object:nil];
    // 获取离线消息
    [[MessageManager share] getMessageList];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    canGotoNotification = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

// 接收到远程推送
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString* ReceiveRemoteNotification = [userInfo objectJsonString];
    NSLog(@"ReceiveRemoteNotification: %@", ReceiveRemoteNotification);
    
    // 暂时不显示弹框
    NSString* alertUrlStr = userInfo[@"alertUrl"];
    NSDictionary* dicAlertUrl = nil;
    if (alertUrlStr && [alertUrlStr isKindOfClass:[NSString class]])
    {
        dicAlertUrl = [NSDictionary JSONValue:alertUrlStr];
    }
    
    if (canGotoNotification && dicAlertUrl && [dicAlertUrl isKindOfClass:[NSDictionary class]])
    {
        [[RemoteNoticationHelper defaultHelper] setAlertInfo:dicAlertUrl];
        canGotoNotification = NO;
        [[RemoteNoticationHelper defaultHelper] gotoNotificationController];
    }

}

- (void) getIOSDeviceToken
{
#if TARGET_IPHONE_SIMULATOR
    NSString* sDeviceToken = [NSString stringWithFormat:@"4738E2B87637E520BBFC955BBF9C82B55905572649E94ABCB0458EA448690EC0"];
    [[NSUserDefaults standardUserDefaults] setObject:sDeviceToken forKey:kIOSDeviceTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self deviceTokenLoaded];
    
#else
    NSString* deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:kIOSDeviceTokenKey];
    if (deviceToken && deviceToken.length > 0) {
        [self deviceTokenLoaded];
        return;
    }
    
    // 消息推送注册
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound|UIUserNotificationTypeAlert|UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
#endif
    
}
- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Action - didFailToRegisterForRemoteNotificationsWithError - %@", error);
    [self deviceTokenLoaded];
}

//ios8需要调用内容
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
    if (UIUserNotificationTypeNone == notificationSettings.types) {
        //系统设置的不接收推送消息。
    }
    [self deviceTokenLoaded];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
    [MessageManager setRemoteNotificationWithDeviceToken:deviceToken];
    // Required - 注册 DeviceToken
    NSString *token = [CommonEncrypt parseByte2HexString:deviceToken];
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kIOSDeviceTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

- (void) deviceTokenLoaded
{
    NSString* deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:kIOSDeviceTokenKey];
    NSLog(@"deviceToken = %@", deviceToken);
    
    if ([self needEntryGuide])
    {
        MainGuideStartViewController* vcGuide = [[MainGuideStartViewController alloc]initWithNibName:nil bundle:nil];
        UIWindow *mainWindow = self.window;
        [mainWindow setRootViewController:vcGuide];
    }
    else
    {
        [self startInitialize];
    }
    //[self startInitialize];
}

- (BOOL) needEntryGuide
{
    return NO;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString* guideVersion= [[NSUserDefaults standardUserDefaults] valueForKey:@"guideVersion"];
    if (guideVersion && [guideVersion isKindOfClass:[NSString class]])
    {
        if ([guideVersion isEqualToString:app_Version])
        {
            return NO;
        }
    }
    return YES;
}

- (void) startInitialize
{
//    InitializationHelper* initHelper = [InitializationHelper defaultHelper];
//    
//    [initHelper startInitialize];
    InitializeViewController* vcInit = [[InitializeViewController alloc]initWithNibName:nil bundle:nil];
    [self.window setRootViewController:vcInit];
}

#pragma mark - Private Method

// 配置IM
- (void)configIMSettings
{
    [MessageManager setAppName:im_appName appToken:im_appToken wsIP:im_IP_ws httpIP:im_IP_http testIP:im_IP_test loginType:@"doctor"];
    [AvatarUtil initAvatarManager];
}

// 配置第三方组件
- (void)conifgThirdLib {
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

//配置友盟
- (void)configUMSDK {
    UMConfigInstance.appKey = @"57fb0f9267e58ed69500029b";
    UMConfigInstance.channelId = NULL;
    UMConfigInstance.ePolicy = BATCH;
    [MobClick setLogEnabled:YES];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];
    
}

@end
