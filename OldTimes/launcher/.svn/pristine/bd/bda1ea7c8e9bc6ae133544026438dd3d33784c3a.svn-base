//
//  SendMessageManager.m
//  launcher
//
//  Created by Lars Chen on 16/1/29.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "SendMessageManager.h"
#import "MessageTimerManager.h"
#import "ContactDetailModel.h"
#import "MessageBaseModel.h"
#import "MsgUserInfoMgr.h"
#import "MessageManagerPrivate.h"
#import "MessageManager.h"
#import "SocketManager.h"

@interface sendMessageModel : NSObject

@property (nonatomic, assign) long long clientMsgId;
@property (nonatomic, copy  ) NSString *socketString;

+ (instancetype)modelWithClientMsgId:(long long)clientMsgId socketString:(NSString *)socketString;

@end

@interface SendMessageManager ()

/// 待发送队列  sendMessageModel
@property (nonatomic, strong) NSMutableArray *sendingMessageList;

@property (nonatomic, assign) BOOL isSending;

@end

@implementation SendMessageManager

+ (SendMessageManager *)share
{
    static SendMessageManager *sendMessageManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sendMessageManager = [[SendMessageManager alloc] init];
    });
    
    return sendMessageManager;
}

- (void)sendMessage:(MessageBaseModel *)message socketString:(NSString *)socketString {
    sendMessageModel *model = [sendMessageModel modelWithClientMsgId:message._clientMsgId socketString:socketString];
    [self.sendingMessageList addObject:model];
    
    if (!self.isSending) {
        [self sendSocketMessage];
    }
}

- (void)sendMessageSuccess {
    if ([self.sendingMessageList count] > 0) {
        [self.sendingMessageList removeObjectAtIndex:0];
    }
    
    self.isSending = NO;
    
    [self sendSocketMessage];
}

- (void)reStart {    
    [self sendSocketMessage];
}

#pragma mark - Private Method

- (void)sendSocketMessage {
    if (![[MessageManager share] isSocketLogin]) {
        return;
    }
    
    sendMessageModel *messageModel = [self.sendingMessageList firstObject];
    if (!messageModel) {
        return;
    }
    
    self.isSending = YES;
    [[SocketManager share] sendMessage:messageModel.socketString];
    [[MessageTimerManager share] addTimerWithCid:messageModel.clientMsgId];
}

#pragma mark - Initializer
- (NSMutableArray *)sendingMessageList {
    if (!_sendingMessageList) {
        _sendingMessageList = [NSMutableArray array];
    }
    return _sendingMessageList;
}

@synthesize dictFirstHistoryRequest = _dictFirstHistoryRequest;
- (NSMutableDictionary *)dictFirstHistoryRequest {
    if (!_dictFirstHistoryRequest) {
        _dictFirstHistoryRequest = [NSMutableDictionary new];
    }
    return _dictFirstHistoryRequest;
}

@end


@implementation sendMessageModel

+ (instancetype)modelWithClientMsgId:(long long)clientMsgId socketString:(NSString *)socketString {
    sendMessageModel *model = [[sendMessageModel alloc] init];
    
    model.clientMsgId = clientMsgId;
    model.socketString = socketString;
    
    return model;
}

@end
