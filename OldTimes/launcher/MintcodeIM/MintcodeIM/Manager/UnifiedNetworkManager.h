//
//  UnifiedNetworkManager.h
//  Titans
//
//  Created by Andrew Shen on 14/10/24.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  监测网络状态

#import <Foundation/Foundation.h>
#import <Reachability/Reachability.h>

extern NSString *const MTNetworkConnectedNotification; // 网络连接成功
extern NSString *const MTNetworkDisconnectedNotification; // 网络连接失败

@interface UnifiedNetworkManager : NSObject

/// 主动检测网络状态
+ (NetworkStatus)getNetworkCurrentStatus;

@end
