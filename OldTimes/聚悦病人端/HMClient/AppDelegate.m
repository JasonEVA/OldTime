//
//  AppDelegate.m
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppDelegate.h"
#import "InitializationHelper.h"
#import "WXApi.h"
#import "CommonEncrypt.h"
#import "MainGuideStartViewController.h"
#import "ActionStatutManager.h"
#import "InitializeViewController.h"
#import "HMStepUploadManager.h"
#import <UMMobClick/MobClick.h>

@interface AppDelegate ()<WXApiDelegate>
{
    BOOL canGotoNotification;
    NSString* wxpayAppId;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 打开日志系统
//    [ATLog configLogEnable:YES];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
//
//    [[HMViewControllerManager defaultManager] entryInitializePage];
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Launch Screen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    UIWindow *mainWindow = self.window;
    [mainWindow setRootViewController:viewController];
    // 配置IM
    [self configIMSettings];
    
    [self configUMSDKS];

    //注册微信
    NSString* appid;
#ifdef kPlantform_JuYue
    appid = @"wx0af8586c46299c2f";
#endif
    
#ifdef kPlantform_ChongYi
    appid = @"wxecf01eefbedf35c2";
#endif
    
#ifdef kPlantform_XiNan
    appid = @"wxacc58ccb2085342a";
#endif
    
    wxpayAppId = appid;
    [WXApi registerApp:wxpayAppId withDescription:@"微信接口测试"];
    
    
    
    [self getIOSDeviceToken];
    
    //return YES;
    // 暂时不显示弹框
    // 处理推送消息

//    canGotoNotification = YES;
    
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
//    //测试退推送打印
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送消息 didFinishLaunchingWithOptions alertUrl" message:[NSString stringWithFormat:@"%@",userInfo] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//    [alert show];

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
//            [[RemoteNoticationHelper defaultHelper] gotoNotificationController];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送消息 didFinishLaunchingWithOptions alertUrl" message:[NSString stringWithFormat:@"%@",userInfo] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//            [alert show];
        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送消息 didFinishLaunchingWithOptions" message:[NSString stringWithFormat:@"%@",userInfo] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//            [alert show];
//        }
        
    }
// 暂时注释，可解决iOS 11下POP回来漂移动画问题
//    if (@available(iOS 11, *)) {
//        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
    
    return YES;
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
    if (ISIOS8)
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound
|UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |
            UIRemoteNotificationTypeSound |
            UIRemoteNotificationTypeAlert];
    }
    
#endif
    
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Action - didFailToRegisterForRemoteNotificationsWithError - %@", error);
    [self deviceTokenLoaded];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
    [MessageManager setRemoteNotificationWithDeviceToken:deviceToken];
    // Required - 注册 DeviceToken
    NSString *token = [CommonEncrypt parseByte2HexString:deviceToken];
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kIOSDeviceTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self deviceTokenLoaded];
    

}

// 接收到远程推送
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    //测试打印
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送消息 didReceiveRemoteNotification alertUrl" message:[NSString stringWithFormat:@"%@",userInfo] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//    [alert show];

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
    
    // 集团用户上传步数
    [[HMStepUploadManager shareInstance] upLoadCurrentStep:^(BOOL success) {
    }];

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


//url Schemes 回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString* scheme = [url scheme];
    NSString* host = [url host];
    
    if ([url.host isEqualToString:@"safepay"])
    {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }

    NSLog(@"openURL %@ %@", scheme, host);
    
    if ([scheme isEqualToString:wxpayAppId]) {
        //微信支付回调
        return [WXApi handleOpenURL:url delegate:self];
    }
    //页面跳转
    [HMViewControllerRouterHelper routerControllerWithUrlString:url.absoluteString];
    
    return NO;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    NSString* scheme = [url scheme];
    NSString* host = [url host];
    
    if ([url.host isEqualToString:@"safepay"])
    {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }

    NSLog(@"openURL %@ %@", scheme, host);
    
    if ([scheme isEqualToString:wxpayAppId]) {
        //微信支付回调
        return [WXApi handleOpenURL:url delegate:self];
    }

    //页面跳转
    [HMViewControllerRouterHelper routerControllerWithUrlString:url.absoluteString];
    
    return NO;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options
{
    NSString* host = [url host];
    if ([host isEqualToString:@"safepay"])
    {
        //支付宝回调
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic)
         {
             NSLog(@"result = %@",resultDic);
             
         }];
        return YES;
    }

    NSString* scheme = [url scheme];
    if ([scheme isEqualToString:wxpayAppId]) {
        //微信支付回调
        return [WXApi handleOpenURL:url delegate:self];
    }
    //页面跳转
    [HMViewControllerRouterHelper routerControllerWithUrlString:url.absoluteString];

    return NO;
}


//微信回调
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"支付成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [[WeiXinPaymentUtil shareInstance] doPayOrderSuccess];
                
                
            }
                break;
                
            default:
            {
                //strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                strMsg = [NSString stringWithFormat:@"支付失败！"];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                [[WeiXinPaymentUtil shareInstance] doPayOrderFailed];
            }
                break;
        }
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
}

//ios8需要调用内容
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
    if (UIUserNotificationTypeNone == notificationSettings.types) {
        //系统设置的不接收推送消息。
        [self startInitialize];
    }
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
    if (deviceToken)
    {
        
    }
//    WelcomeViewController* vcWelcome = [[WelcomeViewController alloc]initWithNibName:nil bundle:nil];
//    [self.window setRootViewController:vcWelcome];
    
    //
    
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
}

- (BOOL) needEntryGuide
{
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
//    [initHelper checknetworkStatus];
    InitializeViewController* vcInit = [[InitializeViewController alloc]initWithNibName:nil bundle:nil];
    [self.window setRootViewController:vcInit];
}
// 配置IM
- (void)configIMSettings
{
    [MessageManager setAppName:im_appName appToken:im_appToken wsIP:im_IP_ws httpIP:im_IP_http testIP:im_IP_test loginType:@"user"];
}

- (void)configUMSDKS {
    UMConfigInstance.appKey = @"57fb0c4767e58eb438002f10";
    UMConfigInstance.channelId = NULL;
    UMConfigInstance.ePolicy = BATCH;
    [MobClick setLogEnabled:YES];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];
    
}
@end
