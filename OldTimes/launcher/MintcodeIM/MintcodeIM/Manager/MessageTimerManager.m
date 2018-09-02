
//
//  MessageTimerManager.m
//  Titans
//
//  Created by Remon Lv on 14-10-24.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "MessageTimerManager.h"
#import "IMConfigure.h"
#import "MsgDefine.h"

@interface MessageTimerManager() {
    NSTimer *_timerLogin;                   // 唯一的login计时器
    NSTimer *_timerLoginKeep;               // 唯一的loginKeep计时器
}

@property (nonatomic, strong)   NSMutableDictionary *dictTimer;        // 保存定时器号的

@end
@implementation MessageTimerManager


// 单例
+ (MessageTimerManager *)share
{
    static MessageTimerManager *messageTimerManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageTimerManager = [[MessageTimerManager alloc] init];
    });
    return messageTimerManager;

}

- (void)destroyMyself
{
    [self removeAllTimers];
    [self stopLoginTimer];
    [self stopLoginKeepTimer];
    [self setDelegate:nil];
}

- (instancetype)init
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(destroyMyself) name:MTWebsocketLogoutNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTWebsocketLogoutNotification object:nil];
}
/** 开启一个消息收发定时器
 */
- (void)addTimerWithCid:(long long)cid
{
    NSTimer *newTimer = [NSTimer scheduledTimerWithTimeInterval:M_V_SEND_TIMEOUT target:self selector:@selector(timeOutWithInfo:) userInfo:[NSNumber numberWithLongLong:cid] repeats:NO];
    [self.dictTimer setObject:newTimer forKey:[NSNumber numberWithLongLong:cid]];
}

/** 销毁一个定时器
 */
- (void)removeTimerWithCid:(long long)cid
{
    NSNumber *number = [NSNumber numberWithLongLong:cid];
    NSTimer *oldTimer = [self.dictTimer objectForKey:number];
    [self.dictTimer removeObjectForKey:number];
    if (oldTimer != nil)
    {
        [oldTimer invalidate];
        oldTimer = nil;
    }    
}

- (void)removeAllTimers {
    NSArray *timerList = [self.dictTimer allValues];
    for (NSTimer *cidTimer in timerList) {
        [cidTimer invalidate];
    }
    [self.dictTimer removeAllObjects];
}

/** 开启一个wsLogin定时器
 */
- (void)startLoginTimer
{
    if (_timerLogin != nil)
    {
        [_timerLogin invalidate];
    }
    _timerLogin = [NSTimer scheduledTimerWithTimeInterval:M_V_LOGIN_TIMEOUT target:self selector:@selector(timeOutForLogin) userInfo:nil repeats:NO];
}

/** 关闭wsLogin定时器
 */
- (void)stopLoginTimer
{
    [_timerLogin invalidate];
}

/** 开启一个wsLoginKeep定时器
 */
- (void)startLoginKeepTimer
{
    if (_timerLoginKeep != nil)
    {
        [_timerLoginKeep invalidate];
    }
    _timerLoginKeep = [NSTimer scheduledTimerWithTimeInterval:M_V_LOGIN_TIMEOUT target:self selector:@selector(timeOutForLoginKeep) userInfo:nil repeats:NO];
}

/** 关闭心跳定时器
 */
- (void)stopLoginKeepTimer
{
    [_timerLoginKeep invalidate];
}

#pragma mark - Private Method
// 超时事件
- (void)timeOutWithInfo:(NSTimer *)timer
{
    // 发送超时委托
    NSNumber *number = [timer userInfo];
    
    if ([self.delegate respondsToSelector:@selector(MessageTimerManagerDelegateCallBack_timerOutWithCid:)])
    {
        [self.delegate MessageTimerManagerDelegateCallBack_timerOutWithCid:[number longLongValue]];
    }
    
    // 销毁定时器
    [self removeTimerWithCid:[number longLongValue]];
}

// login超时事件
- (void)timeOutForLogin
{
    [self stopLoginTimer];
    
    if ([self.delegate respondsToSelector:@selector(MessageTimerManagerDelegateCallBack_timerOutForLogin)])
    {
        [self.delegate MessageTimerManagerDelegateCallBack_timerOutForLogin];
    }
}

// 心跳超时事件
- (void)timeOutForLoginKeep
{
    [self stopLoginKeepTimer];
    
    if ([self.delegate respondsToSelector:@selector(MessageTimerManagerDelegateCallBack_timerOutForLoginKeep)])
    {
        [self.delegate MessageTimerManagerDelegateCallBack_timerOutForLoginKeep];
    }
}

#pragma mark - Init
- (NSMutableDictionary *)dictTimer {
    if (!_dictTimer) {
        _dictTimer = [NSMutableDictionary dictionary];
    }
    return _dictTimer;
}
@end
