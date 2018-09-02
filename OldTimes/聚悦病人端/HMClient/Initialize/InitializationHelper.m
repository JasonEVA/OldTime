//
//  InitializationHelper.m
//  HMClient
//
//  Created by yinquan on 17/1/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "InitializationHelper.h"
#import "VersionUpdateInfo.h"
#import "AppDelegate.h"
#import "InitializeAdvertiseViewController.h"
#import "WXApi.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDK/ShareSDK.h>


#import "AdvertiseInfo.h"

static InitializationHelper* defaultInitializationHelper = nil;

@interface InitializationHelper ()
<TaskObserver>
{
    NSString* upgradeAddress;       //版本升级－AppStore地址
    
    AdvertiseInfo* initAdvertise;
}

@end

@implementation InitializationHelper

+ (InitializationHelper*) defaultHelper
{
    if (!defaultInitializationHelper) {
        defaultInitializationHelper = [[InitializationHelper alloc] init];
    }
    return defaultInitializationHelper;
}

- (void) startInitialize
{
    [self startCheckNetworkStatus];
}

//开始检查网络状态
- (void) startCheckNetworkStatus
{
    AFNetworkReachabilityManager* reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [self setNetworkStatus:status];
        
        [self networkStatusChange:status];
    }];
    
    [reachabilityManager startMonitoring];
}

- (void) networkStatusChange:(AFNetworkReachabilityStatus) status
{
    if (status <= 0)
    {
        
        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        UIViewController *viewController = app.window.rootViewController;

        UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:nil message:@"关闭飞行模式或使用无线局域网来访问数据" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alterVC addAction:okBtn];
        
        [viewController presentViewController:alterVC animated:YES completion:nil];
        
    }
    else
    {
        //网络可用
        NSLog(@"networkStatusChange network status is %ld", status);
        AFNetworkReachabilityManager* reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [reachabilityManager stopMonitoring];
        //检查版本信息
        [self startCheckVersion];
        
    }
    
    
}

- (void) startCheckVersion
{
    //检查版本
    //构造请求参数
    NSMutableDictionary* dicParams = [NSMutableDictionary dictionary];
    [dicParams setValue:[NSString stringWithFormat:@"%ld" ,(long)[PlantformConfig calltype]] forKey:@"typeId"];
    
    [[self windowVC].view showWaitView];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"VersionCheckTask" taskParam:dicParams TaskObserver:self];
}

- (void) updateVersionLoaded:(VersionUpdateInfo*) versionInfo
{
    upgradeAddress = versionInfo.verAddr;
    NSString* upgradeVersion = versionInfo.upgradeVersion; //更新版本号
    NSString* version = versionInfo.verValue;
    NSString* verMsg = versionInfo.verCon;   //版本更新信息
    
    if (!upgradeVersion || ![upgradeVersion isKindOfClass:[NSString class]] || 0 == upgradeVersion.length) {
        [self performSelector:@selector(checkVersionFinished) withObject:nil afterDelay:0.5];
        return;
    }
    NSArray* updateComps = [upgradeVersion componentsSeparatedByString:@"."];
    if (!updateComps || 2 > updateComps.count) {
        [self performSelector:@selector(checkVersionFinished) withObject:nil afterDelay:0.5];
        return;
    }

    NSString* sVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UpdateVersion"];
    if (!sVersion || 0 == sVersion.length)
    {
        [self performSelector:@selector(checkVersionFinished) withObject:nil afterDelay:0.5];
        return;
    }
    
    NSArray* versionComps = [sVersion componentsSeparatedByString:@"."];
    if (!versionComps || 2 > versionComps.count) {
        [self performSelector:@selector(checkVersionFinished) withObject:nil afterDelay:0.5];
        return;
    }
    
    NSString* sUpdate = updateComps[0];
    NSString* sLocalVersion = versionComps[0];
    int iUpdate = sUpdate.intValue;
    int iVersion = sLocalVersion.intValue;
    
    if (iUpdate > iVersion)
    {
        //必须升级
        NSString* alertTitle = [NSString stringWithFormat:@"检测到新版本 v%@", version];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:alertTitle message:verMsg delegate:self cancelButtonTitle:@"升级" otherButtonTitles:nil, nil];
        [alert setTag:0x150];
        [alert show];
        return;
    }
    
    sUpdate = updateComps[1];
    sLocalVersion = versionComps[1];
    iUpdate = sUpdate.intValue;
    iVersion = sLocalVersion.intValue;
    if (iUpdate > iVersion)
    {
        //选择升级
        NSString* alertTitle = [NSString stringWithFormat:@"检测到新版本 v%@", version];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:alertTitle message:verMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
        [alert setTag:0x151];
        [alert show];
        return;
        
    }
    
    //不用升级
    [self performSelector:@selector(checkVersionFinished) withObject:nil afterDelay:0.5];
}

- (void) checkVersionFinished
{
    if ([UserInfoHelper needLogin])
    {
        //跳转到用户登录界面
        
        [[HMViewControllerManager defaultManager] entryUserLoginPage];
        return;
    }
    else
    {
        //初始化ShareSDK
        [self initShareSDK];
        //获取用户信息
       
        [[self windowVC].view showWaitView];

        [[TaskManager shareInstance] createTaskWithTaskName:@"UserInfoTask" taskParam:nil TaskObserver:self];
    }

}


- (void) initShareSDK
{
    [ShareSDK registerApp:@"1b1e195d6f21b"
     
          activePlatforms:@[@(SSDKPlatformTypeWechat),]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
            case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx0af8586c46299c2f"
                                       appSecret:@"d25abdcaa444fdb07dc7853062cd6f8b"];
                 break;
            default:
                 break;
         }
     }];
}

//获取图片
- (void) startLoadPictureServiceUrlPrefix
{
    [[self windowVC].view showWaitView];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"PicServierPathTask" taskParam:nil TaskObserver:self];
}

- (void) pictureServiceUrlPrefix:(NSString*) picUrlPerfix
{
    
    if (!picUrlPerfix || 0 == picUrlPerfix.length) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setValue:picUrlPerfix forKey:@"picUrlPerfix"];
}

//获取是否已经订购服务
- (void) startCheckOrderedService
{
    [[self windowVC].view showWaitView];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"CheckUserServiceTask" taskParam:nil TaskObserver:self];
}


- (BOOL) userHasService
{
    
    NSString* hasServiceStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"hasService"];
    if (hasServiceStr && [hasServiceStr isKindOfClass:[NSString class]])
    {
        return [hasServiceStr isEqualToString:@"Y"];
    }
    return NO;
}

- (BOOL)userHasDispatchService
{
    
    NSString* hasServiceStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"hasDispatchService"];
    if (hasServiceStr && [hasServiceStr isKindOfClass:[NSString class]])
    {
        return [hasServiceStr isEqualToString:@"Y"];
    }
    return NO;
}


//获取启动页广告
- (void) loadStartAdverstice
{
    //
    NSString* advertiseCode = @"IOS_Init_Advertise";
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:advertiseCode forKey:@"code"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"AdvertiseListTask" taskParam:dicPost TaskObserver:self];
}

- (void) advertiseListLoaded:(NSArray*) adverstiseItems
{
    if (adverstiseItems && adverstiseItems.count > 0) {
        if (adverstiseItems.count > 1) {
            initAdvertise = [adverstiseItems firstObject];
        }
        else
        {
            NSInteger randomInex = arc4random() % adverstiseItems.count;
            initAdvertise = adverstiseItems[randomInex];
        }
    }
    
}

//获取服务团队Id
- (void) startLoadServiceTeamId
{
    [[self windowVC].view showWaitView];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceStaffTeamTask" taskParam:nil TaskObserver:self];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [[self windowVC].view closeWaitView];
    
    if (taskError != StepError_None)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(initializeError:Message:)]) {
            [self.delegate initializeError:1 Message:errorMessage];
        }
        return;
    }
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"UserInfoTask"]) {
        //获取到用户基本信息, 获取图片服务器前缀
        [self startLoadPictureServiceUrlPrefix];
    }
    
    if ([taskname isEqualToString:@"PicServierPathTask"])
    {
        //获取到图片服务器前缀，获取用户是否已订购服务
        [self startCheckOrderedService];
    }
    if ([taskname isEqualToString:@"CheckUserServiceTask"])
    {
        //获取到用户是否已订购服务
        if ([self userHasService]) {
            //获取服务团队Id
            [self startLoadServiceTeamId];
        }
        else
        {
            //初始化结束
//            [[HMViewControllerManager defaultManager] entryMainPage];
            //获取启动页广告
            [self loadStartAdverstice];
        }
    }
    
    if ([taskname isEqualToString:@"TeamImGroupIdTask"])
    {
        //初始化结束
//        [[HMViewControllerManager defaultManager] entryMainPage];
        //获取启动页广告
        [self loadStartAdverstice];
    }
    
    if ([taskname isEqualToString:@"AdvertiseListTask"])
    {
        if (initAdvertise) {
            AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            UIViewController* rootViewController = app.window.rootViewController;
            //显示首页广告
            [InitializeAdvertiseViewController showInParentViweController:rootViewController advertiseInfo:initAdvertise];
//            [[HMViewControllerManager defaultManager] entryMainPage];
        }
        else
        {
            //进入首页
            [[HMViewControllerManager defaultManager] entryMainPage];
        }
    }
}



- (void) task:(NSString *)taskId Result:(id) taskResult
{
    [[self windowVC].view closeWaitView];
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"VersionCheckTask"])
    {
        //获取到版本更新信息
        if (taskResult && [taskResult isKindOfClass:[VersionUpdateInfo class]])
        {
            VersionUpdateInfo* versionInfo = (VersionUpdateInfo*) taskResult;
            [self updateVersionLoaded:versionInfo];
        }
        else
        {
            [self performSelector:@selector(checkVersionFinished) withObject:nil afterDelay:0.5];
        }
    }
    if ([taskname isEqualToString:@"PicServierPathTask"])
    {
        //获取到图片服务器地址前缀
        if (taskResult && [taskResult isKindOfClass:[NSString class]])
        {
            [self pictureServiceUrlPrefix:taskResult];
        }
        
        return;
    }
    
    if ([taskname isEqualToString:@"ServiceStaffTeamTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            NSNumber* numTeamId = [dicResult valueForKey:@"teamId"];
            if (numTeamId && [numTeamId isKindOfClass:[NSNumber class]])
            {
                NSString* teamId = [NSString stringWithFormat:@"%ld", numTeamId.integerValue];
                NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
                [dicPost setValue:teamId forKey:@"teamId"];
                
                [[self windowVC].view showWaitView];
                [[TaskManager shareInstance] createTaskWithTaskName:@"TeamImGroupIdTask" taskParam:dicPost TaskObserver:self];
                return;
            }
            else
            {
                [self loadStartAdverstice];
            }
        }
    }
    
    if ([taskname isEqualToString:@"TeamImGroupIdTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSString class]])
        {
            _teamIMGroupID = (NSString*) taskResult;
        }
    }
    if ([taskname isEqualToString:@"AdvertiseListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* items = (NSArray*) taskResult;
            [self advertiseListLoaded:items];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0x150 == alertView.tag) {
        //强制升级
        if (upgradeAddress && 0 != upgradeAddress.length)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:upgradeAddress]];
        }
        exit(0);
        return;
    }
    if (0x151 == alertView.tag)
    {
        if (0 == buttonIndex)
        {
            [self performSelector:@selector(checkVersionFinished) withObject:nil afterDelay:0.5];
            return;
        }
        if (1 == buttonIndex && upgradeAddress && 0 != upgradeAddress.length) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:upgradeAddress]];
            exit(0);
        }
    }
    
    
}

- (UIViewController *)windowVC {
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return app.window.rootViewController;
}
@end
