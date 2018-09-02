//
//  IMMessageHandlingCenter.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "IMMessageHandlingCenter.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "IMNewsModel.h"
@interface IMWeakDelegateObject : NSObject

@property (nonatomic, weak)  id<MessageManagerDelegate>  object; // <##>

+ (instancetype)weakObjectWithObject:(id<MessageManagerDelegate>)object;
- (instancetype)initWithObject:(id<MessageManagerDelegate>)object;

@end

@implementation IMWeakDelegateObject

+ (instancetype)weakObjectWithObject:(id<MessageManagerDelegate>)object {
    return [[[self class] alloc] initWithObject:object];
}

- (instancetype)initWithObject:(id<MessageManagerDelegate>)object {
    if ((self = [super init])) {
        _object = object;
    }
    return self;
}


- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[object class]]) {
        return NO;
    }
    
    return [self isEqualToWeakObject:(IMWeakDelegateObject *)object];
}

- (BOOL)isEqualToWeakObject:(IMWeakDelegateObject *)object {
    if (!object) {
        return NO;
    }
    
    BOOL objectsMatch = [self.object isEqual:object.object];
    return objectsMatch;
}

- (NSUInteger)hash {
    return [self.object hash];
}


@end


@interface IMMessageHandlingCenter ()<MessageManagerDelegate>
@property (nonatomic, strong)  NSMutableSet<IMWeakDelegateObject *>  *delegates; // <##>
@end

@implementation IMMessageHandlingCenter

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (IMMessageHandlingCenter *)sharedInstance {
    static IMMessageHandlingCenter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[IMMessageHandlingCenter alloc] init];
    });
    if (!sharedInstance.alive) {
        [MessageManager share].delegate = sharedInstance;
    }
    return sharedInstance;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [MessageManager share].delegate = self;
    }
    return self;
}

// 注册IM通知
- (void)addIMNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketConnecting) name:MTSocketConnectingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketConnected) name:MTSocketConnectSuccessedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketFailed) name:MTSocketConnectFailedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceLogout:) name:MTLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relationSessionName) name:MTRelationSessionName object:nil];
}

// 移除所有监听
- (void)deregisterAllDelegates {
    if (self.delegates.count > 0) {
        [self.delegates removeAllObjects];
    }
}

// 注册IMDelegate
- (void)registerDelegate:(id<MessageManagerDelegate>)delegate {
    if ([delegate conformsToProtocol:@protocol(MessageManagerDelegate)]) {
        [self.delegates addObject:[IMWeakDelegateObject weakObjectWithObject:delegate]];
    }
}

// 移除IMDelegate
- (void)deregisterDelegate:(id<MessageManagerDelegate>)delegate {
    if ([delegate conformsToProtocol:@protocol(MessageManagerDelegate)]) {
        [self.delegates removeObject:[IMWeakDelegateObject weakObjectWithObject:delegate]];
    }
}

// 是否已经订阅委托
- (BOOL)didRegisterDelegate:(id<MessageManagerDelegate>)delegate {
    BOOL registered = [self.delegates containsObject:[IMWeakDelegateObject weakObjectWithObject:delegate]];
    return registered;
}

#pragma mark - Notification Handler
// socket连接中
- (void)socketConnecting {
    NSLog(@"-------------->socket连接中。。。。");
}

// socket连接成功
- (void)socketConnected {
    NSLog(@"-------------->socket连接成功");
    
}

// socket连接失败
- (void)socketFailed {
    NSLog(@"-------------->socket连接失败");
    
}

// 设备被登出
- (void)deviceLogout:(NSNotification *)noti {
    NSString *warning = @"您与服务器的连接已断开，请重新登录...";
    //    if ([noti.object isKindOfClass:[NSString class]]) {
    //        warning = noti.object;
    //    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设备登出" message:warning preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[HMViewControllerManager defaultManager] userLogout];
    }]];
//    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//    if (rootVC.presentedViewController) {
//        [rootVC dismissViewControllerAnimated:NO completion:nil];
//    }
//    [rootVC presentViewController:alert animated:YES completion:nil];
    
    [[HMViewControllerManager topMostController] presentViewController:alert animated:YES completion:nil];
}

// 好友分组sessionName变化
- (void)relationSessionName {
    
}
// 站内信提醒  =-=Jason加入
- (void)resolvePushMailWithTarget:(NSString *)target {
    if (![target isEqualToString:@"PUSH@SYS"]) {
        return;
    }
    [[MessageManager share] queryBatchMessageWithUid:target MessageCount:1 completion:^(NSArray<MessageBaseModel *> *messages) {
        if (messages.count > 0) {
            MessageBaseModel *latestModel = messages.firstObject;
            NSDictionary *dictContent = [latestModel._content mj_JSONObject];
            // 类型判断
            NSString *messageType = dictContent[@"type"];
            if ([messageType isEqualToString:@"review"] || [messageType isEqualToString:@"medicine"]) {
                // 复查,用药不显示弹框
                return;
            }
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
// 健康课堂提醒  =-=Jason加入
//- (void)resolveNewsMeaaageWithTarget:(NSString *)target {
//    
//    [[MessageManager share] queryBatchMessageWithUid:target MessageCount:1 completion:^(NSArray<MessageBaseModel *> *messages) {
//        if (messages.count > 0) {
//            MessageBaseModel *latestModel = messages.firstObject;
//            // 类型判断
//            if (latestModel._type != msg_personal_news) {
//                return ;
//            }
//            NSString* content = latestModel._content;
//            NSLog(@"自定义消息 %@", content);
//            if (!content || 0 == content.length) {
//                return;
//            }
//            NSDictionary* dicContent = [NSDictionary JSONValue:content];
//            if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
//            {
//                return;
//            }
//            IMNewsModel* modelContent = [IMNewsModel mj_objectWithKeyValues:dicContent];
//
//            NSString *messageString = modelContent.newsTitle;
//            BOOL animated = YES;
//            if ([[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController isKindOfClass:[UIAlertController class]]) {
//                [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//                animated = NO;
//            }
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"健康课堂" message:messageString ?: @"" preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            }]];
//            [alert addAction:[UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                //跳转健康课堂详情
//                [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationDetailViewController" ControllerObject:modelContent];
//                //将这条消息置为已读
//                [[MessageManager share] sendReadedRequestWithUid:target messages:@[latestModel]];
//            }]];
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:animated completion:nil];
//        }
//    }];
//}

#pragma mark - MessageManagerDelegate 

/**
 *  消息重新刷新显示
 *
 *  target＝nil 时为重连成功，若在聊天界面需获取最新消息，并重新获取最新纪录
 *
 *  @param target 某一个会话对象需要刷新
 */
- (void)MessageManagerDelegateCallBack_needRefreshWithTareget:(NSString *)target {
    // 站内信提醒  =-=Jason加入
    [self resolvePushMailWithTarget:target];
//    [self resolveNewsMeaaageWithTarget:target];
    [self.delegates enumerateObjectsUsingBlock:^(IMWeakDelegateObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.object && [obj.object respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithTareget:)]) {
            [obj.object MessageManagerDelegateCallBack_needRefreshWithTareget:target];
        }
    }];
}

/**
 *  发送消息后生成消息的回调
 *
 *  在聊天界面下使用该回调
 *
 [self.showingMessages addObject:message];
 // do Something
 *
 *  @param model 生成的消息,该消息状态为发送中
 */
- (void)MessageManagerDelegateCallBack_needRefreshWithMessageBaseModel:(MessageBaseModel *)model {
    // 站内信提醒  =-=Jason加入
    [self resolvePushMailWithTarget:model._target];
//    [self resolveNewsMeaaageWithTarget:model._target];
    [self.delegates enumerateObjectsUsingBlock:^(IMWeakDelegateObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.object && [obj.object respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithMessageBaseModel:)]) {
            [obj.object MessageManagerDelegateCallBack_needRefreshWithMessageBaseModel:model];
        }
     }];
}

/**
 *  撤回消息后收到的撤回类型的消息的回调
 *
 model.content = {\"clientMsgId\":1456981986187,\"msgId\":1456982289436,\"type\":\"Alert\",\"content\":\"William Zhang啊撤回了一条消息\"}
 content中存放JSON格式数据
 
 例子:
 MessageBaseModel *internalMessage = [model getContentBaseModel];
 // do Something
 *
 *  @param model 撤回类型的消息 content中clientMsgId和msgId匀为要替换的老消息的参数值，type和content为要替换的参数值
 */
- (void)MessageManagerDelegateCallBack_reSendRefreshWithMessageBaseModel:(MessageBaseModel *)model {
    [self.delegates enumerateObjectsUsingBlock:^(IMWeakDelegateObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.object && [obj.object respondsToSelector:@selector(MessageManagerDelegateCallBack_reSendRefreshWithMessageBaseModel:)]) {
            [obj.object MessageManagerDelegateCallBack_reSendRefreshWithMessageBaseModel:model];
        }
    }];
}

/**
 *  收到移除会话指令 （多为跨设备同步数据）
 *
 *  @param target 待移除的会话目标
 */
- (void)MessageManagerDelegateCallBack_removeSessionWithTarget:(NSString *)target {
    [self.delegates enumerateObjectsUsingBlock:^(IMWeakDelegateObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.object && [obj.object respondsToSelector:@selector(MessageManagerDelegateCallBack_removeSessionWithTarget:)]) {
            [obj.object MessageManagerDelegateCallBack_removeSessionWithTarget:target];
        }
    }];
}

/**
 *  收到清除未读条数指令
 *
 *  @param target 待清楚未读条数的会话目标
 */
- (void)MessageManagerDelegateCallBack_clearUnreadWithTarget:(NSString *)target {
    [self.delegates enumerateObjectsUsingBlock:^(IMWeakDelegateObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.object && [obj.object respondsToSelector:@selector(MessageManagerDelegateCallBack_clearUnreadWithTarget:)]) {
            [obj.object MessageManagerDelegateCallBack_clearUnreadWithTarget:target];
        }
    }];
}

/**
 *  接收到别人发送来的消息 (也有可能是自己跨设备发送的同步消息)
 *
 *  在聊天界面下使用该回调
 *
 *  @param model 接收到的消息
 */
- (void)MessageManagerDelegateCallBack_receiveMessage:(MessageBaseModel *)model {
//    [self resolveNewsMeaaageWithTarget:model._target];

    [self.delegates enumerateObjectsUsingBlock:^(IMWeakDelegateObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.object && [obj.object respondsToSelector:@selector(MessageManagerDelegateCallBack_receiveMessage:)]) {
            [obj.object MessageManagerDelegateCallBack_receiveMessage:model];
        }
    }];
}

/**
 *  发送消息成功后收到的回执
 *
 *  有效字段 _clientMsgId、_msgId、_createDate
 *
 *  使用_clientMsgId确认是否是同一条消息
 *
 *  @param model 消息回执
 */
- (void)MessageManagerDelegateCallBack_synchMessage:(MessageBaseModel *)model {
    [self.delegates enumerateObjectsUsingBlock:^(IMWeakDelegateObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.object && [obj.object respondsToSelector:@selector(MessageManagerDelegateCallBack_synchMessage:)]) {
            [obj.object MessageManagerDelegateCallBack_synchMessage:model];
        }
    }];
}

/**
 *  发送消息失败重新发送后需要移除的消息
 *
 *  使用_clientMsgId做去重
 *
 *  @param model 待删除消息
 */
- (void)MessageManagerDelegateCallBack_deleteMessage:(MessageBaseModel *)model {
    [self.delegates enumerateObjectsUsingBlock:^(IMWeakDelegateObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.object && [obj.object respondsToSelector:@selector(MessageManagerDelegateCallBack_deleteMessage:)]) {
            [obj.object MessageManagerDelegateCallBack_deleteMessage:model];
        }
    }];
}

/**
 *  接收对方已经读消息的指令
 *
 *  获取已读_msgId
 *  long long readedMsgId = [model getMsgId];
 // do something
 *
 *  @param model 已读消息
 */
- (void)MessageManagerDelegateCallBack_markReadedMessage:(MessageBaseModel *)model {
    [self.delegates enumerateObjectsUsingBlock:^(IMWeakDelegateObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.object && [obj.object respondsToSelector:@selector(MessageManagerDelegateCallBack_markReadedMessage:)]) {
            [obj.object MessageManagerDelegateCallBack_markReadedMessage:model];
        }
    }];
}

/**
 *  联系人、群信息改变刷新回调
 *
 *  联系人姓名、群成员增删等
 *
 *  @param userProfile
 */
- (void)MessageManagerDelegateCallBack_refreshContactProfileRefresh:(UserProfileModel *)userProfile {
    [self.delegates enumerateObjectsUsingBlock:^(IMWeakDelegateObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.object && [obj.object respondsToSelector:@selector(MessageManagerDelegateCallBack_refreshContactProfileRefresh:)]) {
            [obj.object MessageManagerDelegateCallBack_refreshContactProfileRefresh:userProfile];
        }
    }];
}


/**
 *  附件下载进度
 *
 *  @param progress 0.08
 */
- (void)MessageManagerDelegateCallBack_DataWithProgress:(float)progress {
    [self.delegates enumerateObjectsUsingBlock:^(IMWeakDelegateObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.object && [obj.object respondsToSelector:@selector(MessageManagerDelegateCallBack_DataWithProgress:)]) {
            [obj.object MessageManagerDelegateCallBack_DataWithProgress:progress];
        }
    }];
}

/**
 *  附件下载完成
 *
 *  得到完整路径方法
 NSString *fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:filePath];
 // do something
 *
 *  @param filePath 附件路径
 */
- (void)MessageManagerDelegateCallBack_AttachDownloadFinishWithFileUrl:(NSString *)filePath {
    [self.delegates enumerateObjectsUsingBlock:^(IMWeakDelegateObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.object && [obj.object respondsToSelector:@selector(MessageManagerDelegateCallBack_AttachDownloadFinishWithFileUrl:)]) {
            [obj.object MessageManagerDelegateCallBack_AttachDownloadFinishWithFileUrl:filePath];
        }
    }];
}

/**
 *  附件下载失败
 *
 *  @param message 失败原因
 */
- (void)MessageManagerDelegateCallBack_AttachDownloadFailWithMessage:(NSString *)message {
    [self.delegates enumerateObjectsUsingBlock:^(IMWeakDelegateObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.object && [obj.object respondsToSelector:@selector(MessageManagerDelegateCallBack_AttachDownloadFailWithMessage:)]) {
            [obj.object MessageManagerDelegateCallBack_AttachDownloadFailWithMessage:message];
        }
    }];
}

/**
 *  语音数据下载完成回调
 *
 *  NSString *audioPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeOriginalUrl];
 RMAudioManager *audioManager = [[RMAudioManager alloc] init];
 [audioManager playAudioWithPath:audioPath];
 // do something
 *
 *  @param model 语音下载成功的所在消息
 */
- (void)MessageManagerDelegateCallBack_FinishDownAudioWithMessageBaseModel:(MessageBaseModel *)model {
    [self.delegates enumerateObjectsUsingBlock:^(IMWeakDelegateObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.object && [obj.object respondsToSelector:@selector(MessageManagerDelegateCallBack_FinishDownAudioWithMessageBaseModel:)]) {
            [obj.object MessageManagerDelegateCallBack_FinishDownAudioWithMessageBaseModel:model];
        }
    }];
}

/**
 *  附件上传回调
 *
 *  @param uploadModel  待上传的model，附件路径在_nativeOriginalUrl
 *  @param progress     上传进度 78% progress为1时上传成功
 *  @param failedReason 上传失败原因 若成功，则为nil
 */
- (void)MessageManagerDelegateCallBack_uploadModel:(MessageBaseModel *)uploadModel progress:(double)progress failedReason:(NSString *)failedReason {
    [self.delegates enumerateObjectsUsingBlock:^(IMWeakDelegateObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.object && [obj.object respondsToSelector:@selector(MessageManagerDelegateCallBack_uploadModel:progress:failedReason:)]) {
            [obj.object MessageManagerDelegateCallBack_uploadModel:uploadModel progress:progress failedReason:failedReason];
        }
    }];
}

/**
 *  接收到新消息回调（主要用于播放声音、震动）
 */
- (void)MessageManagerDelegateCallBack_PlaySystemKind {
    [self.delegates enumerateObjectsUsingBlock:^(IMWeakDelegateObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.object && [obj.object respondsToSelector:@selector(MessageManagerDelegateCallBack_PlaySystemKind)]) {
            [obj.object MessageManagerDelegateCallBack_PlaySystemKind];
        }
    }];

}

/**
 *  收到联系人更新消息，增量获取联系人后提示更新的委托
 */
- (void)MessageManagerDelegateCallBack_needRefreshRelationFromSQL {
    [self.delegates enumerateObjectsUsingBlock:^(IMWeakDelegateObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.object && [obj.object respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshRelationFromSQL)]) {
            [obj.object MessageManagerDelegateCallBack_needRefreshRelationFromSQL];
        }
    }];
}

#pragma mark - Init

- (NSMutableSet *)delegates {
    if (!_delegates) {
        _delegates = [NSMutableSet set];
    }
    return _delegates;
}

- (BOOL)alive {
    return [MessageManager share].delegate == self;
}
@end
