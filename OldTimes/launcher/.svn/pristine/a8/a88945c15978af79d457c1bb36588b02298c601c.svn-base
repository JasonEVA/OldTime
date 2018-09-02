//
//  MessageMergeForwardRequest.m
//  MintcodeIM
//
//  Created by williamzhang on 16/3/28.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MessageMergeForwardRequest.h"
#import <MJExtension/MJExtension.h>
#import "MessageBaseModel.h"
#import "NSDate+IMManager.h"
#import "MsgUserInfoMgr.h"

@implementation MessageMergeForwardRequest

+ (void)forwardMessages:(NSArray<MessageBaseModel *> *)messages
                  title:(NSString *)title
                toUsers:(NSArray *)toUsers
                isMerge:(BOOL)isMerge
             completion:(IMBaseResponseCompletion)completion
{
    MessageMergeForwardRequest *request = [[MessageMergeForwardRequest alloc] init];
    
    NSDictionary *info = @{@"nickName":[[MsgUserInfoMgr share] getNickName],
                           @"userName":[[MsgUserInfoMgr share] getUid]};
    
    
    request.params[@"info"]  = [info mj_JSONString];
    request.params[@"type"]  = @"MergeMessage";
    request.params[@"to"]    = toUsers;
    request.params[@"title"] = title;
    
    if (!isMerge) {
        request.params[@"oneByOne"] = @YES;
    } else {
        long long cid = [NSDate wzim_currentTimestamp];
        long long lastSendingCid = [[MsgUserInfoMgr share] getCid];
        if (lastSendingCid == cid) {
            cid ++;
        }
        [[MsgUserInfoMgr share] saveCid:cid];
        
        request.params[@"clientMsgId"] = @(cid);
    }
    
    NSMutableArray *array = [NSMutableArray array];
    messages = [messages sortedArrayUsingComparator:^NSComparisonResult(MessageBaseModel *obj1, MessageBaseModel *obj2) {
        if (obj1._msgId < obj2._msgId) {
            return NSOrderedAscending;
        }
        else if (obj1._msgId > obj2._msgId) {
            return NSOrderedDescending;
        }
        
        return NSOrderedSame;
    }];
    
    for (MessageBaseModel *message in messages) {
        [array addObject:[self dictionaryFromMessage:message]];
    }
    
    request.params[@"content"] = array;
    [request requestDataCompletion:completion];
}

+ (NSDictionary *)dictionaryFromMessage:(MessageBaseModel *)message {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    dictionary[@"from"]        = message._fromLoginName;
    dictionary[@"type"]        = [MessageBaseModel getStringFromMsgType:message._type];
    dictionary[@"createDate"]  = @(message._createDate);
    dictionary[@"clientMsgId"] = @(message._clientMsgId);
    dictionary[@"msgId"]       = @(message._msgId);
    dictionary[@"content"]     = message._content;
    dictionary[@"modified"]    = @(message._modified);
    dictionary[@"info"]        = message._info;
    
    return dictionary;
}

- (NSString *)action { return @"/forwardMergeMessage"; }

@end
