//
//  RecallMessageRequest.m
//  launcher
//
//  Created by williamzhang on 16/1/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "RecallMessageRequest.h"
#import "MessageBaseModel.h"
#import "MsgUserInfoMgr.h"

@implementation RecallMessageRequest

- (NSString *)action { return @"/resendmsg";}

+ (void)recallMessage:(MessageBaseModel *)message completion:(IMBaseResponseCompletion)completion {
    RecallMessageRequest *request = [[RecallMessageRequest alloc] init];
    
    request.params[@"type"] = [MessageBaseModel getStringFromMsgType:msg_personal_alert];
    request.params[@"content"] = [NSString stringWithFormat:@"%@撤回了一条消息", [message getNickName]];
    request.params[@"from"] = message._fromLoginName;
    request.params[@"to"] = message._toLoginName;
    request.params[@"createDate"] = @(message._createDate);
    request.params[@"clientMsgId"] = @(message._clientMsgId);
    request.params[@"msgId"] = @(message._msgId);
    request.params[@"info"] = message._info;
    request.params[@"modified"] = [[MsgUserInfoMgr share] getModified];
    
    [request requestDataCompletion:^(IMBaseResponse *response, BOOL success) {
        completion(response, success);
    }];
}

@end
