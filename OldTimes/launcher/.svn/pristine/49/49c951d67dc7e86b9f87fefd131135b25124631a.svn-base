//
//  GetHistoryMessageRequest.m
//  launcher
//
//  Created by Lars Chen on 15/10/30.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "GetHistoryMessageRequest.h"
#import "MsgDefine.h"
#import "MessageBaseModel+Private.h"
#import "ContactDetailModel.h"
#import "NSDictionary+IMSafeManager.h"
#import "MsgUserInfoMgr.h"

static NSString *d_limit = @"limit";
static NSString *d_endTimeStamp = @"endTimestamp";
static NSString *d_to = @"to";

static NSString *d_msg = @"msg";
static NSString *d_UnReadCount = @"unReadCount";

@implementation GetHistoryMessageResponse

@end

@implementation GetHistoryMessageRequest
- (NSString *)action { return @"/historymessage";}

- (void)prepareRequest
{
    self.params[d_limit] = [NSNumber numberWithInteger:self.limit];
    if (self.endTimestamp != -1) {
        self.endTimestamp -= 1;
    }
    self.params[@"hh"] = @(YES);
    // 会把endTimeStamp这条也返回
    self.params[d_endTimeStamp] = [NSNumber numberWithLongLong:self.endTimestamp];
    self.params[d_to] = self.strUid;
    
    [super prepareRequest];
}

- (IMBaseResponse *)prepareResponse:(NSDictionary *)data
{
    GetHistoryMessageResponse *response = [GetHistoryMessageResponse new];
    NSArray *arrDictMsg = [data im_valueArrayForKey:d_msg];
    response.arrMsgBaseModel = [NSMutableArray arrayWithCapacity:arrDictMsg.count];
    for (NSDictionary *dict in arrDictMsg)
    {
        if (!dict) {
            continue;
        }
        
        MessageBaseModel *baseModel = [[MessageBaseModel alloc] initWithDict:dict];
        BOOL markReaded = [dict im_valueBoolForKey:d_UnReadCount];
        
        if (![baseModel._toLoginName isEqualToString:[[MsgUserInfoMgr share] getUid]]) {
            // TODO: 自己的信息有几人读了 之后加 服务器还没完成此功能
            baseModel._markReaded = !markReaded;
        } else {
            // 别人发给我，判断是否已读 0 是已读
            baseModel._markReaded = !markReaded;
        }
        
        [response.arrMsgBaseModel addObject:baseModel];
    }
    
    response.arrMsgBaseModel = [NSMutableArray arrayWithArray:[response.arrMsgBaseModel reverseObjectEnumerator].allObjects];
    
    return response;
}

@end


@implementation GetHistoryMessageBlockRequest

- (NSString *)action { return @"/historymessage";}

+ (void)sessionName:(NSString *)sessionName MessageCount:(NSInteger)messageCount endTimestamp:(long long)endTimestamp completion:(IMBaseResponseCompletion)completion {
    NSMutableArray *messageHistoryList = [NSMutableArray array];
    [self requestWithSessionName:sessionName MessageCount:messageCount endTimestamp:endTimestamp completion:completion loadedHistory:messageHistoryList];
}

+ (instancetype)requestWithSessionName:(NSString *)sessionName
                       MessageCount:(NSInteger)messageCount
                       endTimestamp:(long long)endTimestamp
                         completion:(IMBaseResponseCompletion)completion
                      loadedHistory:(NSMutableArray *)loadedHistoryList
{
    GetHistoryMessageBlockRequest *request = [[GetHistoryMessageBlockRequest alloc] init];
    request.params[d_limit] = @(messageCount);
    request.params[d_to] = sessionName;
    request.params[@"hh"] = @(YES);
    if (endTimestamp != -1) {
        endTimestamp -= 1;
    }
    request.params[d_endTimeStamp] = @(endTimestamp);
    
    __block NSMutableArray *messageHistoryList = loadedHistoryList;
    
    [request requestDataCompletion:^(IMBaseResponse *response, BOOL success) {
        BOOL allResendMessage = YES;
        NSArray *messageList = [(id)response arrMsgBaseModel];
        for (MessageBaseModel *message in messageList) {
            if (message._type != msg_personal_reSend) {
                allResendMessage = NO;
                break;
            }
        }
        
        [messageHistoryList insertObjects:messageList atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messageList count])]];
        
        if (![messageList count] || !allResendMessage) {
            completion(response, success);
            return;
        }
        
        MessageBaseModel *oldMessage = [messageHistoryList firstObject];
        long long endNewTimestamp = endTimestamp;
        if (oldMessage) {
            endNewTimestamp = oldMessage._msgId;
        }
        
        [self requestWithSessionName:sessionName MessageCount:messageCount endTimestamp:endNewTimestamp completion:completion loadedHistory:messageHistoryList];
    }];
    
    return request;
}

- (IMBaseResponse *)prepareResponse:(NSDictionary *)data
{
    GetHistoryMessageResponse *response = [GetHistoryMessageResponse new];
    NSArray *arrDictMsg = [data im_valueArrayForKey:d_msg];
    
    NSDictionary *lastDict = [arrDictMsg lastObject];
    // 最后一条lastMsgId
    long long lastMsgId = LONG_LONG_MAX;
    if (lastDict) {
        MessageBaseModel *lastModel = [[MessageBaseModel alloc] initWithDict:lastDict];
        lastMsgId = lastModel._msgId;
    }
    
    response.arrMsgBaseModel = [NSMutableArray arrayWithCapacity:arrDictMsg.count];
    for (NSDictionary *dict in arrDictMsg)
    {
        if (!dict) {
            continue;
        }
        
        MessageBaseModel *baseModel = [[MessageBaseModel alloc] initWithDict:dict];
        BOOL markReaded = [dict im_valueBoolForKey:d_UnReadCount];
        
        if (![baseModel._toLoginName isEqualToString:[[MsgUserInfoMgr share] getUid]]) {
            // TODO: 自己的信息有几人读了 之后加 服务器还没完成此功能
            baseModel._markReaded = !markReaded;
        } else {
            // 别人发给我，判断是否已读 0 是已读
            baseModel._markReaded = !markReaded;
        }
        
        if (baseModel._type == msg_personal_reSend && [baseModel getContentBaseModel]._msgId >= lastMsgId) {
            // 撤回在条数内,直接显示
            MessageBaseModel *internalMessage = [baseModel getContentBaseModel];
            baseModel._type = internalMessage._type;
            baseModel._msgId = internalMessage._msgId;
            baseModel._clientMsgId = internalMessage._clientMsgId;
            baseModel._content = internalMessage._content;
        }
        
        [response.arrMsgBaseModel addObject:baseModel];
    }
    
    response.arrMsgBaseModel = [NSMutableArray arrayWithArray:[response.arrMsgBaseModel reverseObjectEnumerator].allObjects];
    
    return response;
}

@end
