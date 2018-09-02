//
//  IMMessageHelper.m
//  HMClient
//
//  Created by yinqaun on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "IMMessageHelper.h"

static IMMessageHelper* defaultIMMessageHelper = nil;

@interface MessageManagerObserver : NSObject
{
    
}
@property (nonatomic, weak) id<MessageManagerDelegate> delegate;
@end

@implementation MessageManagerObserver;


@end

@interface IMMessageHelper ()
<MessageManagerDelegate>
{
    NSMutableArray* observers;
}
@end


@implementation IMMessageHelper

+ (IMMessageHelper*) defaultHelper
{
    if (!defaultIMMessageHelper)
    {
        defaultIMMessageHelper = [[IMMessageHelper alloc]init];
        
    }
    
    return defaultIMMessageHelper;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        [MessageManager setAppName:im_appName appToken:im_appToken wsIP:im_IP_ws httpIP:im_IP_http testIP:im_IP_test loginType:@"user"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imSocketConnecting:) name:@"MTSocketConnectingNotification" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imSocketConnectSuccess:) name:@"MTSocketConnectSuccessedNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imSocketConnectFailed:) name:@"MTSocketConnectFailedNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceLogout:) name:MTLogoutNotification object:nil];
        observers = [NSMutableArray array];
        [[MessageManager share] setDelegate:self];
    }
    return self;
}

- (void) addMessageDelegate:(id<MessageManagerDelegate>) delegate
{
    [[MessageManager share] setDelegate:self];
    if (!delegate)
    {
        return;
    }
    MessageManagerObserver* observer = nil;
    for (MessageManagerObserver* existedObserver in observers)
    {
        if(existedObserver.delegate == delegate)
        {
            return;
        }
    }
    
    observer = [[MessageManagerObserver alloc]init];
    [observer setDelegate:delegate];
    
    [observers addObject:observer];
}


- (void) imSocketConnecting:(NSNotification*) noticification
{
    NSLog(@"imSocketConnecting");
}

- (void) imSocketConnectSuccess:(NSNotification*) noticification
{
    NSLog(@"imSocketConnectSuccess");
}

- (void) imSocketConnectFailed:(NSNotification*) noticification
{
    NSLog(@"imSocketConnectFailed");
}

// 设备被登出
- (void)deviceLogout:(NSNotification *)noti {
    NSString *warning = @"您与服务器的连接已断开，请重新登录......";
    //    if ([noti.object isKindOfClass:[NSString class]]) {
    //        warning = noti.object;
    //    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设备登出" message:warning preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[MessageManager share] logout];
        [[UserInfoHelper defaultHelper] userlogout];
        
        [[HMViewControllerManager defaultManager] entryUserLoginPage];
    }]];
    
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    [[HMViewControllerManager topMostController] presentViewController:alert animated:YES completion:nil];
    
}

- (void) removeInvalidObservers
{
    NSArray* allObservices = [NSArray arrayWithArray:observers];
    
    for(MessageManagerObserver* observer in allObservices)
    {
        if (!observer.delegate) {
            [observers removeObject:observer];
        
        }
    }
}

// 处理站内信推送
- (void)resolvePushMailWithTarget:(NSString *)target {
    if (![target isEqualToString:@"PUSH@SYS"]) {
        return;
    }
    [[MessageManager share] queryBatchMessageWithUid:target MessageCount:1 completion:^(NSArray<MessageBaseModel *> *messages) {
        if (messages.count > 0) {
            MessageBaseModel *latestModel = messages.firstObject;
            NSDictionary *dictContent = [latestModel._content mj_JSONObject];
            NSString *messageString = dictContent[@"msg"];
            if (messageString.length == 0) {
                NSDictionary *dictInfo = [latestModel._info mj_JSONObject];
                messageString = dictInfo[@"alertContent"];

            }
            BOOL animated = YES;
            if ([[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController isKindOfClass:[UIAlertController class]]) {
                [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                animated = NO;
            }
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新消息" message:messageString ?: @"" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:animated completion:nil];
        }
    }];
}

#pragma mark MessageManagerDelegate
- (void)MessageManagerDelegateCallBack_needRefreshWithTareget:(NSString *)target
{
    // 站内信提醒
    [self resolvePushMailWithTarget:target];
    [self removeInvalidObservers];
    for (MessageManagerObserver* observer in observers)
    {
        if (observer.delegate && [observer.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithTareget:)])
        {
            [observer.delegate MessageManagerDelegateCallBack_needRefreshWithTareget:target];
        }
    }
}

- (void)MessageManagerDelegateCallBack_needRefreshWithMessageBaseModel:(MessageBaseModel *)model
{
    [self resolvePushMailWithTarget:model._target];
    [self removeInvalidObservers];
    for (MessageManagerObserver* observer in observers)
    {
        if (observer.delegate && [observer.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithMessageBaseModel:)])
        {
            [observer.delegate MessageManagerDelegateCallBack_needRefreshWithMessageBaseModel:model];
        }
    }
}

- (void)MessageManagerDelegateCallBack_needRefreshWithOfflineMessage
{
    NSLog(@"MessageManagerDelegateCallBack_needRefreshWithOfflineMessage ...");
}

- (void) MessageManagerDelegateCallBack_FinishDownAudioWithMessageBaseModel:(MessageBaseModel *)model
{
    for (MessageManagerObserver* observer in observers)
    {
        if (observer.delegate && [observer.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_FinishDownAudioWithMessageBaseModel:)])
        {
            [observer.delegate MessageManagerDelegateCallBack_FinishDownAudioWithMessageBaseModel:model];
        }
    }
}

- (void)MessageManagerDelegateCallBack_clearUnreadWithTarget:(NSString *)target {
    NSLog(@"MessageManagerDelegateCallBack_clearUnreadWithTarget %@",target);
}


- (void)MessageManagerDelegateCallBack_refreshContactProfileRefresh:(UserProfileModel *)userProfile
{
    for (MessageManagerObserver* observer in observers)
    {
        if (observer.delegate && [observer.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_refreshContactProfileRefresh:)])
        {
            [observer.delegate MessageManagerDelegateCallBack_refreshContactProfileRefresh:userProfile];
        }
    }

}

@end
