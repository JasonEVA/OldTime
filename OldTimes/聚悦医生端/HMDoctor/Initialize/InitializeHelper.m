//
//  InitializeHelper.m
//  HMDoctor
//
//  Created by yinquan on 17/1/5.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "InitializeHelper.h"
#import "PlantformConfig.h"
#import "VersionUpdateInfo.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "AdvertiseInfo.h"
#import "InitializeAdvertiseViewController.h"

static InitializeHelper* defaultInitializeHelper = nil;

@interface InitializeHelper ()
<TaskObserver>
{
    NSString* upgradeAddress;
    AdvertiseInfo* initAdvertise;
}
@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;

@end

@implementation InitializeHelper

+ (InitializeHelper*) defaultHelper
{
    if (!defaultInitializeHelper) {
        defaultInitializeHelper = [[InitializeHelper alloc]init];
        
    }
    return defaultInitializeHelper;
}

- (void) startInitialize
{
    //检查网络状态
    [self checkNetworkStatus];
}

- (void) checkNetworkStatus
{
    AFNetworkReachabilityManager* reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    __weak typeof(self) weakSelf = self;
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf setNetworkStatus:status];
        
        [strongSelf networkStatusChange:status];
    }];
    
    [reachabilityManager startMonitoring];
}

- (void) networkStatusChange:(AFNetworkReachabilityStatus) status
{
    if (status <= 0)
    {
        //网络不可用
        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        UIViewController *viewController = app.window.rootViewController;
        
        UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:nil message:@"关闭飞行模式或使用无线局域网来访问数据" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alterVC addAction:okBtn];
        
        [viewController presentViewController:alterVC animated:YES completion:nil];
        return;
    }
    else
    {
        //网络可用，继续初始化过程
        NSLog(@"networkStatusChange network status is %ld", status);
        AFNetworkReachabilityManager* reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [reachabilityManager stopMonitoring];
        [HealthPlanUtil shareInstance];
        [self startCheckUpdateVersion];
    }
    
    
    
}

//开始检查版本更新
- (void) startCheckUpdateVersion
{
    [[self windowVC].view showWaitView];
    
    NSMutableDictionary* dicParams = [NSMutableDictionary dictionary];
    [dicParams setValue:[NSString stringWithFormat:@"%ld" ,(long)[PlantformConfig calltype]] forKey:@"typeId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"VersionCheckTask" taskParam:dicParams TaskObserver:self];
}

//解析判断版本更新信息
- (void) updateVersionInfoLoaded:(VersionUpdateInfo*) versionInfo
{
    upgradeAddress = versionInfo.verAddr;
    NSString* upgradeVersion = versionInfo.upgradeVersion;
    NSString* version = versionInfo.verValue;
    NSString* verMsg = versionInfo.verCon;
    
    if (!upgradeVersion || ![upgradeVersion isKindOfClass:[NSString class]] || 0 == upgradeVersion.length) {
        [self performSelector:@selector(updateVersionFinish) withObject:nil afterDelay:0.5];
        return;
    }
    NSArray* updateComps = [upgradeVersion componentsSeparatedByString:@"."];
    if (!updateComps || 2 > updateComps.count) {
        [self performSelector:@selector(updateVersionFinish) withObject:nil afterDelay:0.5];
        return;
    }
    
    //UpdateVersion
    NSString* sVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UpdateVersion"];
    if (!sVersion || 0 == sVersion.length)
    {
        [self performSelector:@selector(updateVersionFinish) withObject:nil afterDelay:0.5];
        return;
    }
    NSArray* versionComps = [sVersion componentsSeparatedByString:@"."];
    if (!versionComps || 2 > versionComps.count) {
        
        [self performSelector:@selector(updateVersionFinish) withObject:nil afterDelay:0.5];
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
    [self performSelector:@selector(updateVersionFinish) withObject:nil afterDelay:0.5];
}

- (void) updateVersionFinish
{
    if ([self needUserLogin]) {
        //用户尚未登录，进入用户登录界面
        [[HMViewControllerManager defaultManager] startUserLogin];
    }
    else
    {
        //用户已经登录，获取用户－医生信息
        [self startLoadStaffInfo];
    }
}

//判断是否需要用户登录
- (BOOL) needUserLogin
{
    BOOL needUserLogin = NO;
    UserInfo* curUser = [UserInfoHelper defaultHelper].currentUserInfo;
    if (!curUser)
    {
        needUserLogin = YES;
    }
    return needUserLogin;
}

//获取用户－医生信息
- (void) startLoadStaffInfo
{
    [[self windowVC].view showWaitView];
    
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    NSMutableDictionary* dicParam = [NSMutableDictionary dictionary];
    [dicParam setValue:[NSString stringWithFormat:@"%ld", curStaff.staffId] forKey:@"staffId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"LoadStaffInfoTask" taskParam:dicParam TaskObserver:self];
    
}



//获取图片服务地址前缀
- (void) startLoadPictureServiePrefix
{
    [[self windowVC].view showWaitView];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"PicServierPathTask" taskParam:nil TaskObserver:self];
}

- (void) pictureServicePrefix:(NSString*) picUrlPerfix
{
    if (0 == picUrlPerfix.length) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setValue:picUrlPerfix forKey:@"picUrlPerfix"];
}

//获取医生操作权限
- (void) startLoadStaffPrivilege
{
    [[self windowVC].view showWaitView];
    
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.userId] forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"StaffPrivilegeTask" taskParam:dicPost TaskObserver:self];
    
}

// 获取医生快速入组权限
- (void)startLoadStaffInGroupPermission {
    
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    NSMutableDictionary* dicParam = [NSMutableDictionary dictionary];
    [dicParam setValue:[NSString stringWithFormat:@"%ld", curStaff.userId] forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMGetUserInGroupPermissionRequest" taskParam:dicParam TaskObserver:self];
}

//获取启动页广告

- (void) loadInitAdvertise
{
    NSString* advertiseCode = @"IOS_Init_Advertise_Doctor";
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

- (void) entryMainStart
{
    [[HMViewControllerManager defaultManager] entryMainStart];
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
    
    //获取到医生信息
    if ([taskname isEqualToString:@"LoadStaffInfoTask"])
    {
        [self startLoadPictureServiePrefix];
    }
    
    if ([taskname isEqualToString:@"PicServierPathTask"]) {
        [self startLoadStaffPrivilege];

    }
    
    //获取到医生相关操作权限 StaffPrivilegeTask
    if ([taskname isEqualToString:@"StaffPrivilegeTask"])
    {
        [self startLoadStaffInGroupPermission];
    }
    
    if ([taskname isEqualToString:@"HMGetUserInGroupPermissionRequest"]) {
        //初始化过程结束，进入首页
//        [[HMViewControllerManager defaultManager] entryMainStart];
        //获取启动页广告
        [self loadInitAdvertise];
    }
    
    if ([taskname isEqualToString:@"AdvertiseListTask"])
    {
        if (initAdvertise) {
            AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            UIViewController* rootViewController = app.window.rootViewController;
            //显示首页广告
            [InitializeAdvertiseViewController showInParentViweController:rootViewController advertiseInfo:initAdvertise];
           
        }
        else
        {
            //进入首页
            [self entryMainStart];
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
            [self updateVersionInfoLoaded:versionInfo];
        }
        else
        {
            [self performSelector:@selector(updateVersionFinish) withObject:nil afterDelay:0.5];
        }
    }
    
    if ([taskname isEqualToString:@"PicServierPathTask"]) {
        //获取到图片服务地址前缀
        if (taskResult && [taskResult isKindOfClass:[NSString class]])
        {
            NSString* picUrlPerfix = (NSString*) taskResult;
            [self pictureServicePrefix:picUrlPerfix];
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
            [self performSelector:@selector(updateVersionFinish) withObject:nil afterDelay:0.5];
            return;
        }
        if (1 == buttonIndex && upgradeAddress && 0 != upgradeAddress.length) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:upgradeAddress]];
            exit(0);
        }
    }
//    if (alertView.tag == 0x170) {
//        //网络连接失败，退出App
//        exit(0);
//        return;
//    }
    
    
}

- (UIViewController *)windowVC {
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return app.window.rootViewController;
}

@end
