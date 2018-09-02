//
//  ChattingModule.m
//  launcher
//
//  Created by williamzhang on 15/12/31.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChattingModule.h"
#import <MintcodeIM/MintcodeIM.h>
#import "NSDictionary+SafeManager.h"
#import "UnifiedUserInfoManager.h"
#import "Slacker.h"

NSInteger wz_page_item_count = 20;
NSInteger wz_default_needVoice_msgId = -1;
#define T_NOTIFYSOUND 2.0           // 两条消息提醒最小间隔

/// 消息显示时间的最大间隔 (300s * 1000)
static NSInteger const wz_max_timeInterval = 300000;

@interface ChattingModule () <MessageManagerDelegate>

@property (nonatomic, strong) MessageManager *manager;

/// 接收消息block
@property (nonatomic, copy) WZChatReceiveCompletion      receiveCompletion;
/// 获取最新block
@property (nonatomic, copy) WZChatReloadIfNeedCompletion reloadIfNeedCompletion;
// 刷新某条block
@property (nonatomic, copy) WZChatRefreshArrModelCompletion refreshArrModelCompletion;

@property (nonatomic, copy) void (^sendMessageCompletion)();
/// 刷新数据block（仅用于[tableView reloadData]）
@property (nonatomic, copy) void (^reloadMessagesCompletion)();
@property (nonatomic, copy) WZChatPlayVoiceCompletion playVoiceCompletion;
@property (nonatomic, copy) void (^willLoadLatestCompletion)();

@property (nonatomic, copy) void (^handleErrorMessageBlock)(NSString *);

/// 获取本地历史
@property (nonatomic, assign) BOOL getLocalHistory;

@property (nonatomic)  NSTimeInterval currTimeInterval;           // 当前时间，为消息间隔服务

/// 存储date所在位置（createDate:anyObject）
@property (nonatomic, strong) NSMutableDictionary *dateDictionary;
@property (nonatomic, assign) long long latestDateInterval;

@end

@implementation ChattingModule

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentNeedPlayVoiceMsgId = wz_default_needVoice_msgId;
        
        _currTimeInterval = [[NSDate date] timeIntervalSince1970];

    }
    return self;
}

#pragma mark - Load
- (void)loadLocalMessagesCompletion:(void (^)())completion {
    if (!completion) {
        return;
    }
    
    NSInteger messageCount = [self showingMessagesCountWithoutDate];
    if (messageCount < wz_page_item_count) {
        messageCount = wz_page_item_count;
    }
    [self.manager queryBatchMessageWithUid:self.sessionModel._target MessageCount:messageCount completion:^(NSArray *messages) {

        [self.showingMessages removeAllObjects];
        [self.showingMessages addObjectsFromArray:[self handleDateIfNeedWithMessages:messages]];
        
        completion();
    }];
}

- (void)loadHistoryCompletion:(WZChatReloadIfNeedCompletion)completion {
    self.reloadIfNeedCompletion = completion;
//    !self.willLoadLatestCompletion ?: self.willLoadLatestCompletion();
    [self getLatestHistory];
}

- (void)loadMoreHistoryCompletion:(WZChatLoadHistoryCompletion)completion {
    
    NSParameterAssert(completion);
    
    if (self.getLocalHistory) {
        [self queryMessageCount:wz_page_item_count + [self showingMessagesCountWithoutDate] completion:completion];
        return;
    }
    
    
    void (^loadLocalHistory)() = ^{
        [self.manager queryBatchMessageWithUid:self.sessionModel._target
                                  MessageCount:(wz_page_item_count + [self showingMessagesCountWithoutDate])
                                    completion:^(NSArray *messages) {
                                        NSInteger messageCount = [self showingMessagesCount];
                                        
                                        [self.showingMessages removeAllObjects];
                                        [self.showingMessages addObjectsFromArray:[self handleDateIfNeedWithMessages:messages]];
                                        
                                        NSInteger addCount = [self showingMessagesCount] - messageCount;
                                        if ([self.showingMessages count] == 0) {
                                            addCount --;
                                        }
                                        
                                        if (addCount < 0) {
                                            addCount = 0;
                                        }
                                        
                                        [self setReadMessages];
                                        
                                        completion(addCount);
                                    }];
    };
    
    
    MessageBaseModel *oldestMessage = [self firstObejctWithoutDate];
    [self.manager getHistoryMessageWithUid:self.sessionModel._target
                              messageCount:wz_page_item_count
                              endTimestamp:oldestMessage ? oldestMessage._msgId : - 1
                                completion:^(NSArray *messages, BOOL success)
    {
        if (!success) {
            [self queryMessageCount:wz_page_item_count + [self showingMessagesCountWithoutDate] completion:completion];
            return;
        }
        
        [self compareResendMessage:messages];
        loadLocalHistory();
    }];
}

#pragma mark - block set
- (void)reloadIfNeedCompletion:(WZChatReloadIfNeedCompletion)completion {
    self.reloadIfNeedCompletion = completion;
}

- (void)refreshReSendMessage:(WZChatRefreshArrModelCompletion)completion {
    self.refreshArrModelCompletion = completion;
}

- (void)receiveMessage:(WZChatReceiveCompletion)completion {
    self.receiveCompletion = completion;
}

- (void)sendMessage:(void (^)())completion {
    self.sendMessageCompletion = completion;
}

- (void)playVoice:(WZChatPlayVoiceCompletion)completion {
    self.playVoiceCompletion = completion;
}

- (void)reloadMessages:(void (^)())completion {
    self.reloadMessagesCompletion = completion;
}

- (void)willLoadLatestHistory:(void (^)())completion {
    self.willLoadLatestCompletion = completion;
}

- (void)handleErrorMessage:(void (^)(NSString *))errorBlock {
    self.handleErrorMessageBlock = errorBlock;
}

- (void)alive:(BOOL)alive {
    self.manager.delegate = alive ? self : nil;
}

- (BOOL)isAlive {
    return self.manager.delegate == self;
}

#pragma mark - Read
- (void)setReadMessages {
    MessageBaseModel *firstMessage = [self firstObejctWithoutDate];
    
    if (!firstMessage) {
        [self sendReadMessageRequestWith:@[]];
        return;
    }

    [[MessageManager share] getAllUnReadedMessageListWithUid:[self sessionUid] msgId:firstMessage._msgId completion:^(NSArray *unreadMessages) {
        [self sendReadMessageRequestWith:unreadMessages];
    }];
}

#pragma mark - MessageManager Delegate
- (void)MessageManagerDelegateCallBack_receiveMessage:(MessageBaseModel *)model {
    if (![model._target isEqualToString:[self sessionUid]]) {
        return;
    }
    
    BOOL fromSelf = [model._fromLoginName isEqualToString:[[UnifiedUserInfoManager share] userShowID]];
    BOOL chatSelf = [model._toLoginName isEqualToString:model._fromLoginName] && [model._target isEqualToString:[[UnifiedUserInfoManager share] userShowID]];
    
    if (chatSelf) {
        // 自己与自己聊天
        
        __block BOOL syncSuccess = NO;
        [self.showingMessages enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(MessageBaseModel *message, NSUInteger idx, BOOL * _Nonnull stop) {
            if (message._clientMsgId == model._clientMsgId) {
                message._markStatus = status_send_success;
                message._msgId = model._msgId;
                message._clientMsgId = model._clientMsgId;

                syncSuccess = YES;
                *stop = YES;
            }
        }];
        
        if (syncSuccess) {
            // 已存在，同步完成
            !self.receiveCompletion ?:self.receiveCompletion();
            return;
        }
    }
    
    [self addMessageAfterHandle:model];
    if (!fromSelf) {
        // 不是自己发的，需要发请求一读
        [self sendReadMessageRequestWith:@[model]];
    }
    
    !self.receiveCompletion ?: self.receiveCompletion();
}

- (void)MessageManagerDelegateCallBack_needRefreshWithTareget:(NSString *)target {
    if (!target) {
        // 重连 获取最新消息
        !self.willLoadLatestCompletion ?: self.willLoadLatestCompletion();
        [self getLatestHistory];
        return;
    }
    
    if (![target isEqualToString:[self sessionUid]]) {
        return;
    }
    
    [self.manager queryBatchMessageWithUid:[self sessionUid] MessageCount:[self showingMessagesCountWithoutDate] completion:^(NSArray *messages) {
        
        [self.showingMessages removeAllObjects];
        [self.showingMessages addObjectsFromArray:[self handleDateIfNeedWithMessages:messages]];
        
        self.reloadIfNeedCompletion(NO, YES, -1);
    }];
}

- (void)MessageManagerDelegateCallBack_FinishDownAudioWithMessageBaseModel:(MessageBaseModel *)model {
    if (![model._target isEqualToString:[self sessionUid]]) {
        return;
    }
    
    if (self.currentNeedPlayVoiceMsgId == !model._msgId) {
        return;
    }
    
    if (model._markFromReceive) {
        model._markReaded = YES;
        [self sendReadMessageRequestWith:@[model]];
    }
    
    NSString *filePath = [[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeOriginalUrl];
    NSAssert(self.playVoiceCompletion != nil, @"请设置playVoice:");
    self.playVoiceCompletion(model._msgId,filePath);
}

/// 发送消息
- (void)MessageManagerDelegateCallBack_needRefreshWithMessageBaseModel:(MessageBaseModel *)model {
    if (![model._target isEqualToString:[self sessionUid]]) {
        return;
    }
    
    [self addMessageAfterHandle:model];
    NSAssert(self.sendMessageCompletion != nil, @"请设置sendMessage:");
    self.sendMessageCompletion();
}

// 撤回消息
- (void)MessageManagerDelegateCallBack_reSendRefreshWithMessageBaseModel:(MessageBaseModel *)model
{
    [self refreshIndexPathsWithArrModel:@[model]];
}

- (void)MessageManagerDelegateCallBack_synchMessage:(MessageBaseModel *)model {
    __block BOOL needReload = NO;
    
    [self.showingMessages enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(MessageBaseModel *message, NSUInteger idx, BOOL * _Nonnull stop) {
        if (message._clientMsgId != model._clientMsgId) {
            return;
        }
        
        needReload = YES;
        message._markStatus = status_send_success;
        message._msgId = model._msgId;
        message._clientMsgId = model._clientMsgId;
        *stop = YES;
    }];
    
    if (needReload) {
        // 处理自己的消息回执
        !self.receiveCompletion ?: self.receiveCompletion();
    }
}

- (void)MessageManagerDelegateCallBack_refreshContactProfileRefresh:(UserProfileModel *)userProfile {
    if (![userProfile.userName isEqualToString:[self sessionUid]]) {
        return;
    }
    
    UserProfileModel *model = [self.manager queryContactProfileWithUid:[self sessionUid]];
    self.sessionModel._nickName = model.nickName;
}

- (void)MessageManagerDelegateCallBack_deleteMessage:(MessageBaseModel *)model {
    if (![model._target isEqualToString:[self sessionUid]]) {
        return;
    }
    
    for (MessageBaseModel *message in self.showingMessages) {
        if (model._clientMsgId == message._clientMsgId) {
            [self.showingMessages removeObject:message];
            break;
        }
    }
    
    self.reloadIfNeedCompletion(NO, YES, -1);
}

- (void)MessageManagerDelegateCallBack_markReadedMessage:(MessageBaseModel *)model {
    if (![model._target isEqualToString:[self sessionUid]]) {
        return;
    }
    
    NSAssert(self.reloadMessagesCompletion != nil, @"请使用reloadMessages:");
    
    // 性能有问题 暂时不用 williamzzz
    long long msgIdNeedRead = [model getMsgId];
    NSArray *array = [self.showingMessages copy];
    
    dispatch_async(self.manager.messageQueue, ^{
        for (NSInteger i = array.count - 1; i >= 0; i --) {
            MessageBaseModel *message = [array objectAtIndex:i];
            if (msgIdNeedRead == message._msgId) {
                message._markReaded = YES;
                break;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.reloadMessagesCompletion();
        });
    });
}
// 新消息提醒
- (void)MessageManagerDelegateCallBack_PlaySystemKind
{
    // 消息提醒
    // 刷新消息列表数据
    // 播放声效提醒
    // 根据时间间隔播放声音
    NSTimeInterval newTimeInterval = [[NSDate date] timeIntervalSince1970];
    if ((newTimeInterval - _currTimeInterval) > T_NOTIFYSOUND)
    {
        [Slacker playNotifySoundIntellective];
        _currTimeInterval = newTimeInterval;
    }
    
}

- (void)MessageManagerDelegateCallBack_uploadModel:(MessageBaseModel *)uploadModel progress:(double)progress failedReason:(NSString *)failedReason {
    if (!failedReason) {
        !self.reloadMessagesCompletion ?: self.reloadMessagesCompletion();
        return;
    }
    
    !self.handleErrorMessageBlock ?: self.handleErrorMessageBlock(failedReason);
}

#pragma mark - Private Method
- (void)getLatestHistory {
    
    !self.willLoadLatestCompletion ?: self.willLoadLatestCompletion();
    
    void (^loadLocalLatestData)() = ^{
        [self.manager queryBatchMessageWithUid:self.sessionModel._target
                                  MessageCount:(wz_page_item_count)
                                    completion:^(NSArray *messages)
         {
             NSInteger insertCount = -1; // 计算需要加载的新消息在原来的哪个位置
             NSArray *handledMessages = [self handleDateIfNeedWithMessages:messages]; // 处理过的messages
             
             MessageBaseModel *lastMessage = [self.showingMessages lastObject];
             if (lastMessage) {
                 for (NSInteger i = [handledMessages count] - 1; i >= 0; i --) {
                     MessageBaseModel *message = [handledMessages objectAtIndex:i];
                     if (message._clientMsgId != lastMessage._clientMsgId || ![message._fromLoginName isEqualToString:lastMessage._fromLoginName]) {
                         // 是否为同一条消息
                         continue;
                     }
                     
                     insertCount = i;
                     break;
                 }
             }
             
             [self.showingMessages removeAllObjects];
             [self.showingMessages addObjectsFromArray:handledMessages];
             
             [self setReadMessages];
             !self.reloadIfNeedCompletion ?: self.reloadIfNeedCompletion(YES, YES, insertCount);
         }];
    };
    
    // 获取最新的消息
    [self.manager getHistoryMessageWithUid:self.sessionModel._target
                              messageCount:wz_page_item_count
                              endTimestamp:-1
                                completion:^(NSArray *messages, BOOL success)
    {
        if (!success) {
            self.getLocalHistory = YES;
            !self.reloadIfNeedCompletion ?: self.reloadIfNeedCompletion(YES, NO, -1);
            return;
        }
        
        [self compareResendMessage:messages];
        loadLocalLatestData();
    }];
}

- (NSString *)sessionUid {
    return self.sessionModel._target;
}

- (NSUInteger)showingMessagesCount {
    return [self.showingMessages count];
}

- (NSUInteger)showingMessagesCountWithoutDate {
    return [self.showingMessages count] - [self.dateDictionary allKeys].count;
}

/// 本地获取最新数量级的消息
- (void)queryMessageCount:(NSInteger)count completion:(WZChatLoadHistoryCompletion)completion {
    [self.manager queryBatchMessageWithUid:[self sessionUid] MessageCount:count completion:^(NSArray *messages) {
        NSArray *handledMessages = [self handleDateIfNeedWithMessages:messages];
        NSInteger addCount = [handledMessages count] - [self showingMessagesCount];
        
        [self.showingMessages removeAllObjects];
        [self.showingMessages addObjectsFromArray:handledMessages];
        
        completion(addCount);
    }];
}

/// 消息设置为已读
- (void)sendReadMessageRequestWith:(NSArray *)messages {
    [self.manager sendReadedRequestWithUid:[self sessionUid] messages:messages];
}

/// 解析resend指令得到需要刷新的数组 重新计算高度
- (void)refreshIndexPathsWithArrModel:(NSArray *)arrData
{
    NSMutableArray *arrIndexpaths = [NSMutableArray array];
    MessageBaseModel *model = [arrData firstObject];
    if (![model._target isEqualToString:[self sessionUid]]) {
        return;
    }
    
    for (MessageBaseModel *model in arrData)
    {
        NSIndexPath *indexPath = [NSIndexPath new];
        
        for (NSInteger i = [self showingMessagesCount] - 1; i >= 0 ;i --) {
            MessageBaseModel *message = [self.showingMessages objectAtIndex:i];
            MessageBaseModel *internalMessage = [model getContentBaseModel];
            if (message._clientMsgId != internalMessage._clientMsgId) {
                continue;
            }
            
            if (message._type == internalMessage._type && [message._content isEqualToString:internalMessage._content]) {
                // 已经替换过了撤回指令
                continue;
            }
            
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            model._msgId = message._msgId;
            model._clientMsgId = internalMessage._clientMsgId;
            model._content = internalMessage._content;
            model._type = internalMessage._type;
            [arrIndexpaths addObject:indexPath];
            
            [self.showingMessages replaceObjectAtIndex:indexPath.row withObject:model];
            break;
        }
    }
    
    // resend刷新原来那条高度
    if (arrIndexpaths.count > 0) {
        self.refreshArrModelCompletion(arrIndexpaths);
    }
}

/// 计算并得到要撤回指令的消息
- (void)compareResendMessage:(NSArray *)messages {
    NSMutableArray *arrResendModels = [NSMutableArray array];
    for (MessageBaseModel *baseModel in messages)
    {
        if (baseModel._type == msg_personal_reSend)
        {
            [arrResendModels addObject:baseModel];
        }
    }
    
    if (![arrResendModels count]) return;
    
    // 取出撤回指令重新计算高度 无需刷新页面 下面有reload
    [self refreshIndexPathsWithArrModel:arrResendModels];
}

/// 处理时间，有需要则加入时间显示条
- (NSArray *)handleDateIfNeedWithMessages:(NSArray *)messages {
    NSMutableArray *messageList = [NSMutableArray array];
    
    NSMutableDictionary *dictionaryTmp = [self.dateDictionary mutableCopy];
    
    long long lastMessageCreateDate = 0;
    for (NSInteger i = 0; i < [messages count]; i ++) {
        MessageBaseModel *message = [messages objectAtIndex:i];
        MessageBaseModel *dateMessage = nil;
        
        if (message._type == msg_usefulMsgMin) {
            continue;
        }
        
        if ([dictionaryTmp objectForKey:[NSNumber numberWithLongLong:message._createDate]]) {
            dateMessage = [[MessageBaseModel alloc] initWithTimeStamp:message._createDate];
            lastMessageCreateDate = message._createDate;
            [dictionaryTmp removeObjectForKey:[NSNumber numberWithLongLong:message._createDate]];
        }
        
        else if (lastMessageCreateDate + wz_max_timeInterval < message._createDate) {
            dateMessage = [[MessageBaseModel alloc] initWithTimeStamp:message._createDate];
            lastMessageCreateDate = message._createDate;
            [self.dateDictionary setObject:@1 forKey:[NSNumber numberWithLongLong:message._createDate]];
        }
        
        if (dateMessage) {
            [messageList addObject:dateMessage];
            self.latestDateInterval = dateMessage._createDate;
        }
        [messageList addObject:message];
    }
    
    return messageList;
}

/// 加入消息时先处理看是否需要加入时间
- (void)addMessageAfterHandle:(MessageBaseModel *)message {
    MessageBaseModel *latestMessage = [self.showingMessages lastObject];
    
    if (latestMessage._clientMsgId == message._clientMsgId && latestMessage._msgId == message._msgId) {
        return;
    }
    
    if (!latestMessage || self.latestDateInterval + wz_max_timeInterval < message._createDate) {
    
        MessageBaseModel *dateMessage = [[MessageBaseModel alloc] initWithTimeStamp:message._createDate];
        [self.showingMessages addObject:dateMessage];
        self.latestDateInterval = message._createDate;
    }
    
    [self.showingMessages addObject:message];
}

/// 获取列表上第一条消息（除去时间）
- (MessageBaseModel *)firstObejctWithoutDate {
    MessageBaseModel *firstMessage = [self.showingMessages firstObject];
    
    if (firstMessage._type == msg_other_timeStamp) {
        if ([self.showingMessages count] > 1) {
            // 获取到非时间类型
            firstMessage = [self.showingMessages objectAtIndex:1];
        } else {
            firstMessage = nil;
        }
    }
    
    return firstMessage;
}

#pragma mark - Initializer
- (NSMutableArray *)showingMessages {
    if (!_showingMessages) {
        _showingMessages = [NSMutableArray array];
    }
    return _showingMessages;
}

- (MessageManager *)manager {
    return [MessageManager share];
}

- (ContactDetailModel *)sessionModel {
    if (!_sessionModel) {
        _sessionModel = [ContactDetailModel new];
    }
    return _sessionModel;
}

- (NSMutableDictionary *)dateDictionary {
    if (!_dateDictionary) {
        _dateDictionary = [NSMutableDictionary dictionary];
    }
    return _dateDictionary;
}

@end
