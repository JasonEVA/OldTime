//
//  UnifiedNetworkManager.m
//  Titans
//
//  Created by Andrew Shen on 14/10/24.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "UnifiedNetworkManager.h"
#import "MsgUserInfoMgr.h"
#import "IMConfigure.h"

/// 网络连接成功
NSString *const MTNetworkConnectedNotification    = @"MTNetworkConnectedNotification";
/// 网络连接失败
NSString *const MTNetworkDisconnectedNotification = @"MTNetworkDisconnectedNotification";

@interface UnifiedNetworkManager()

@property (nonatomic, strong) Reachability *reach;

@end

@implementation UnifiedNetworkManager

+ (UnifiedNetworkManager *)share
{
    static UnifiedNetworkManager *networkManager = nil;
    static dispatch_once_t singleNetworkManager;
    dispatch_once(&singleNetworkManager, ^{
        networkManager = [[self alloc] init];
    });
    return networkManager;
}

- (instancetype)init
{
    if (self = [super init])
    {
        // 初始化实时网络监控类
        [self initReachability];
    }
    return self;
}

- (void)initReachability
{
    // 测试网络地址能否连通，测试接口地址http://192.168.1.65:9088，全程监视，网络状态改变即通知
    self.reach = [Reachability reachabilityWithHostname:[[MsgUserInfoMgr share] getTestIp]];
    
    // 网络恢复正常
    [Reachability reachabilityWithHostname:[[MsgUserInfoMgr share] getTestIp]].reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 发送委托网络恢复
            [[NSNotificationCenter defaultCenter] postNotificationName:MTNetworkConnectedNotification object:nil];
        });
    };
    // 网络不通
    [Reachability reachabilityWithHostname:[[MsgUserInfoMgr share] getTestIp]].unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 发送委托网络断开
            [[NSNotificationCenter defaultCenter] postNotificationName:MTNetworkDisconnectedNotification object:nil];
        });
    };
    [[Reachability reachabilityWithHostname:[[MsgUserInfoMgr share] getTestIp]] startNotifier];
}

// 得到网络状态
+ (NetworkStatus)getNetworkCurrentStatus
{
    return [[self share].reach currentReachabilityStatus];
}
@end
