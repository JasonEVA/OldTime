//
//  MessageTimerManager.h
//  Titans
//
//  Created by Remon Lv on 14-10-24.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  消息发送定时器 下城

#import <Foundation/Foundation.h>

@protocol MessageTimerManagerDelegate <NSObject>

@optional
/// 某个消息超时的委托
- (void)MessageTimerManagerDelegateCallBack_timerOutWithCid:(long long)cid;

/// login超时的委托
- (void)MessageTimerManagerDelegateCallBack_timerOutForLogin;

/// loginKeep超时的委托
- (void)MessageTimerManagerDelegateCallBack_timerOutForLoginKeep;

@end

@interface MessageTimerManager : NSObject

@property (nonatomic,weak) id <MessageTimerManagerDelegate> delegate;

/// 单例
+ (MessageTimerManager *)share;
//- (void)destroyMyself;


/// 开启一个定时器
- (void)addTimerWithCid:(long long)cid;
/// 销毁一个定时器
- (void)removeTimerWithCid:(long long)cid;

/// 销毁所有cid定时器
- (void)removeAllTimers;

/// 开启一个login定时器
- (void)startLoginTimer;
/// 关闭login定时器
- (void)stopLoginTimer;

/// 开启一个心跳定时器
- (void)startLoginKeepTimer;
/// 关闭心跳定时器
- (void)stopLoginKeepTimer;

@end
