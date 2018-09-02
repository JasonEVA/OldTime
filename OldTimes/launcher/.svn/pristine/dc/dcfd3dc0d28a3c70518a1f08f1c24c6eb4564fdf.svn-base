//
//  AppDelegate.m
//  launcher
//
//  Created by William Zhang on 15/7/24.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#if CHINAMODE
#ifndef DEBUG
#import "UIActionSheet+Util.h"
#import "WebViewController.h"
#import <BugHD/BugHD.h>
#import <KSCrash/KSCrashInstallationStandard.h>
#endif
#endif

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "MixpanelMananger.h"
#import "UnifiedLoginManager.h"
#import "UnifiedUserInfoManager.h"
#import "SettingModel.h"
#import <MintcodeIM/MintcodeIM.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "IMApplicationEnum.h"
#import "ChatIMConfigure.h"
#import <AMapFoundation/AMapFoundationKit/AMapServices.h>

//适配iOS10
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()

@end

static NSString *const kGoogleApiKey = @"AIzaSyCH4g_jil4Pd8cmJKvfxdlqdcjVZg0ejT4";

#if (defined(JAPANMODE))
    static NSString *const kMixpanelKey  = @"4e1265a0caa761695c68db1cf95345e2"; //-- 正式
#else
    static NSString *const kMixpanelKey  = @"7330f58d2e377a26b9307a17b57b4f77"; //-- 测试
#endif

//@"4e1265a0caa761695c68db1cf95345e2"; -- 正式版
static NSString *const touchCode = @"touchCode";
static NSString *const touchChat = @"touchChat";
static NSString *const touchSearch = @"touchSearch";
static NSString *const touchCalendar = @"touchCalendar";

static NSString *const kBaiDuMapApiKey = @"EoW4aQPdOoOUzF4rewhSVMPU";     //百度地图Key

//考勤部分
static NSString *const k_punchCard_updateTime_Notification = @"updateTime";
static NSString *const k_punchCard_updateLocation_Notificatiion = @"updateLocation";

static NSString *const k_UserLoginOut_Notitication = @"userTokenFailed";

@implementation AppDelegate

#pragma mark - App Life Cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.controllerManager = [[RootViewControllerManager alloc] initWithWindow:self.window];
    [self.controllerManager loginWays];
    [self.window makeKeyAndVisible];

    [self configureMintCodeIMSetting];
    
    [self configureGoogleMapService];
    
    [self configureUserBehaviorTrakService];
    
    [self configureRemoteNotificationService];
    
    [self configure3DTouchSetting];
    
    [self configureLogRecordService];
    
    // 要使用百度地图，请先启动BaiduMapManager
    [self configureBaiduMapService];
    
    /** 高德API key配置 (考勤模块) */
    [AMapServices sharedServices].apiKey = @"07bd435562123460f02668aa97a14653";
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 发送底部栏未读消息条数变化的通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SET_TABBAR_MSG_COUNT object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSString *loginName = [[UnifiedUserInfoManager share] getAccountWithEncrypt:YES];
    SettingModel *settingModel = [[UnifiedLoginManager share] findDataModelWithLoginName:loginName];
    BOOL isLogin;
    if (settingModel)
    {
        isLogin = [settingModel.isLogin boolValue];
    }
    // 重新连接socket
    if (isLogin)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:MTSocketConnectingNotification object:nil];
        
        // 获取离线消息
        [[NSNotificationCenter defaultCenter] postNotificationName:M_N_GETMESSAGELIST object:nil];
    }
    
    //考勤部分
    [[NSNotificationCenter defaultCenter] postNotificationName:k_punchCard_updateTime_Notification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:k_punchCard_updateLocation_Notificatiion object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
#if CHINAMODE
#ifndef DEBUG
    [self setupBugHD];
#endif
#endif
}

- (void)applicationWillTerminate:(UIApplication *)application {
}


#pragma mark - Configure MinitCodeIM
/**
 *  配置公司的Mintcode IM框架
 */
- (void)configureMintCodeIMSetting {
    [MessageManager setApplicationConfig:@{
                                           im_task_uid:@(IM_Applicaion_task),
                                           im_approval_uid:@(IM_Applicaion_approval),
                                           im_schedule_uid:@(IM_Applicaion_schedule)
                                           }];
    [MessageManager setAppName:im_appName appToken:im_appToken wsIP:im_IP_ws httpIP:im_IP_http testIP:im_IP_test loginType:nil];
    
}

#pragma mark - Configure Mixpanle SDK
/**
 *  配置用户行为服务框架Mixpanel
 */
- (void)configureUserBehaviorTrakService {
    [MixpanelMananger installToken:kMixpanelKey];
}

#pragma mark - Configure BaiduMap SDK
/**
 *  配置百度地图SDK,使用前必须启动BaiduMapManager
 */
- (void)configureBaiduMapService {
    self._mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [self._mapManager start:kBaiDuMapApiKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
   
}

#pragma mark - Configure GoogleMap SDK
/**
 *  配置谷歌地图SDK
 */
- (void)configureGoogleMapService {
    [GMSServices provideAPIKey:kGoogleApiKey];
}

#pragma mark - Configure 日志记录
/**
 *  使用DDLog进行24小时间隔的日志记录
 */
- (void)configureLogRecordService {
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling 24小时换个文件记录日志
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;     //文件最大数量
    [DDLog addLogger:fileLogger];
}

#pragma mark - Configure BugHD
#if CHINAMODE
#ifndef DEBUG
/**
 *  配置Bug检测分析框架BugHD
 */
- (void)setupBugHD {
    
    KSCrashInstallationStandard *installation = [KSCrashInstallationStandard sharedInstance];
    installation.url = [NSURL URLWithString:@"https://collector.bughd.com/kscrash?key=3f9732269a5eb10a87aa2de047f57f26"];
    [installation install];
    [installation sendAllReportsWithCompletion:nil];
    
    [BugHD handleCrashWithKey:@"3f9732269a5eb10a87aa2de047f57f26"];
    
}

#endif
#endif

#pragma mark - Configure RemoteNotification
/**
 *  远程推送的配置
 */
- (void)configureRemoteNotificationService {
    // 消息推送注册
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        //注册启用push
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge];
        
    }
    else if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 10)
    {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             
                                                                             settingsForTypes:(UIUserNotificationTypeSound|UIUserNotificationTypeAlert|UIUserNotificationTypeBadge)
                                                                             
                                                                             categories:nil]];
        
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] > 9.9)
    {
        UNUserNotificationCenter *center =  [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound)  completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {

                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                }];
            } else {
                //点击不允许
                NSLog(@"注册通知失败");
            }
        }];
        
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}


#pragma mark - RemoteNotification Delegate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    token = [[token substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)];
    
    // 去掉空格
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSLog(@"😝😝😝😝%@",token);
//    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"code" message:token delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
//    [alter show];
    // 保存 device token 令牌
    [[UnifiedUserInfoManager share] saveRemoteNotifyToken:token];
    [MessageManager setRemoteNotificationWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //    NSLog(@"Failed to get token, error:%@ %@", userInfo,application);
    /* 在此处理接收到的消息，包含了推送消息和资讯最后一条信息ID，以及版本控制,结构如下
     {  aps =
     {
     alert = sdfsd;
     badge = 1;
     sound = "sound.caf";
     };
     newsId = 12345;
     osVer = "1.4.1";
     }
     */
    
    //    NSLog(@"Receive remote notification : %@",userInfo);
    
    // 发送本地消息
    //    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_REMOTE_NEWINFO object:self userInfo:userInfo];
}

#pragma mark - Configure 3DTouch
/**
 *  3DTouch的配置
 */
- (void)configure3DTouchSetting {
    if (IOS_VERSION_9_OR_ABOVE) {
        [self createItems];
    }
    
}

- (void)createItems
{
    // 3D Touch
    //菜单图标
    UIApplicationShortcutIcon *iconCode = [UIApplicationShortcutIcon iconWithTemplateImageName:@"Touch_Code"];
    //菜单文字
    UIMutableApplicationShortcutItem *itemCode = [[UIMutableApplicationShortcutItem alloc] initWithType:touchCode localizedTitle:LOCAL(QUICK_QRCODE)];
    //绑定信息到指定菜单
    itemCode.icon = iconCode;
    
    UIApplicationShortcutIcon *iconChat = [UIApplicationShortcutIcon iconWithTemplateImageName:@"Touch_Chat"];
    UIMutableApplicationShortcutItem *itemChat = [[UIMutableApplicationShortcutItem alloc] initWithType:touchChat localizedTitle:LOCAL(QUICK_NEW_CHAT)];
    itemChat.icon = iconChat;
    
    UIApplicationShortcutIcon *iconSearch = [UIApplicationShortcutIcon iconWithTemplateImageName:@"Touch_Search"];
    UIMutableApplicationShortcutItem *itemSearch = [[UIMutableApplicationShortcutItem alloc] initWithType:touchSearch localizedTitle:LOCAL(SEARCH)];
    itemSearch.icon = iconSearch;
    
    UIApplicationShortcutIcon *iconCalendar = [UIApplicationShortcutIcon iconWithTemplateImageName:@"Touch_Calendar"];
    UIMutableApplicationShortcutItem *itemCalendar = [[UIMutableApplicationShortcutItem alloc] initWithType:touchCalendar localizedTitle:LOCAL(QUICK_NEW_SCHEDULE)];
    itemCalendar.icon = iconCalendar;
    
    //绑定到App icon
    [UIApplication sharedApplication].shortcutItems = @[itemCode,itemChat,itemSearch,itemCalendar];
}


/**
 *  针对指定Item启动,程序响应3DTouch事件的方法回调
 */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    if ([shortcutItem.type isEqualToString:touchCode]) {
        [self.controllerManager beginQRCode];
    }
    else if ([shortcutItem.type isEqualToString:touchChat])
    {
        [self.controllerManager beginChat];
    }
    else if ([shortcutItem.type isEqualToString:touchSearch])
    {
        [self.controllerManager beginSearch];
    }
    else if ([shortcutItem.type isEqualToString:touchCalendar])
    {
        [self.controllerManager beginNewCalendar];
    }
}

- (void)tokenFiledLoginOut
{
    AppDelegate *aDelegate = [UIApplication sharedApplication].delegate;
    [aDelegate.controllerManager showPasswordLoginViewForValid];
}

#pragma mark - Core Data stack
//
//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
//
//- (NSURL *)applicationDocumentsDirectory {
//    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.mintcode.launcher" in the application's documents directory.
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}
//
//- (NSManagedObjectModel *)managedObjectModel {
//    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"launcher" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}
//
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
//    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//
//    // Create the coordinator and store
//
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"launcher.sqlite"];
//    NSError *error = nil;
//    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        // Report any error we got.
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
//        dict[NSUnderlyingErrorKey] = error;
//        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
//        // Replace this with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//
//    return _persistentStoreCoordinator;
//}
//
//
//- (NSManagedObjectContext *)managedObjectContext {
//    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (!coordinator) {
//        return nil;
//    }
//    _managedObjectContext = [[NSManagedObjectContext alloc] init];
//    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    return _managedObjectContext;
//}
//
//#pragma mark - Core Data Saving support
//
//- (void)saveContext {
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        NSError *error = nil;
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}

@end
