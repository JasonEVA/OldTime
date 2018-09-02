//
//  IMMessageHandlingCenter.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//  IM消息处理中心

#import <Foundation/Foundation.h>

@protocol MessageManagerDelegate;

@interface IMMessageHandlingCenter : NSObject

@property (nonatomic, assign, readonly)  BOOL  alive; // IM委托状态
@property (nonatomic, assign)  BOOL  sessionRefreshing; // 会话刷新中

+ (IMMessageHandlingCenter *)sharedInstance;

// 注册IM通知
- (void)addIMNotifications;

// 注册IMDelegate
- (void)registerDelegate:(id<MessageManagerDelegate>)delegate;

// 移除IMDelegate
- (void)deregisterDelegate:(id<MessageManagerDelegate>)delegate;

// 是否已经订阅委托
- (BOOL)didRegisterDelegate:(id<MessageManagerDelegate>)delegate;
@end
