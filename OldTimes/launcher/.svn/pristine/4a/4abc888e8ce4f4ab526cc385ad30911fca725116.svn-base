//
//  GetUnreadSessionRequest.m
//  launcher
//
//  Created by Lars Chen on 15/10/30.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "GetUnreadSessionRequest.h"
#import "NSDictionary+IMSafeManager.h"
#import "ContactDetailModel+Private.h"
#import "MessageBaseModel+Private.h"
#import "MsgUserInfoMgr.h"
#import "MsgDefine.h"
#import "RemoveSessionRequest.h"
#import <MJExtension/MJExtension.h>

static NSString * const d_start = @"start";
static NSString * const d_end   = @"end";

static NSString * const d_sessions         = @"sessions";
static NSString * const d_sessionName      = @"sessionName";
static NSString * const d_count            = @"count";
static NSString * const d_lastMsg          = @"lastMsg";
static NSString * const d_nickName         = @"nickName";
static NSString * const d_muteNotification = @"muteNotification";
static NSString * const d_tag              = @"tag";

static NSString * const d_removeSessions = @"removesessions";

NSInteger unReadSessionGetCount = 20;

@implementation GetUnreadSessionResponse
@end

// ------------------ 使用msgId字段获取 ------------------ //
@implementation GetUnreadSessionBlockRequest

- (NSString *)action { return @"/unreadsession";}

+ (void)getSessionCompletion:(void (^)(GetUnreadSessionResponse *, BOOL))completion {
    NSParameterAssert(completion);
    
    GetUnreadSessionBlockRequest *request = [GetUnreadSessionBlockRequest new];

    long long maxMsgId = [[[MsgUserInfoMgr share] getMaxMsgId] longLongValue];
    if (maxMsgId == 0) {
        request.params[d_start] = @0;
        request.params[d_end] = @100;
    } else {
        request.params[@"msgId"] = @(maxMsgId);
    }
    
    [request requestDataCompletion:^(IMBaseResponse *response, BOOL success) {
        completion((id)response, success);
    }];
}

- (IMBaseResponse *)prepareResponse:(NSDictionary *)data
{
    GetUnreadSessionResponse *response = [GetUnreadSessionResponse new];
    
    NSArray *arrSessions = [data im_valueArrayForKey:d_sessions];
    response.arrContactModel = [NSMutableArray arrayWithCapacity:arrSessions.count];
    for (NSDictionary *sessionDict in arrSessions)
    {
        NSDictionary *dictMsg = [sessionDict im_valueDictonaryForKey:d_lastMsg];
        if (!dictMsg) continue;
        
        MessageBaseModel *baseModel = [[MessageBaseModel alloc] initWithDict:dictMsg];
        if (baseModel._type == msg_usefulMsgMin) {
            continue;
        }
        
        if (baseModel._type == msg_personal_reSend)
        {
            MessageBaseModel *newBaseModel = [baseModel getContentBaseModel];
            baseModel._content = newBaseModel._content;
            baseModel._type = newBaseModel._type;
        }
        ContactDetailModel *contactModel = [[ContactDetailModel alloc] initWithMessageBaseModel:baseModel];
        
        if (contactModel._isApp == NO)
        {
            if (!contactModel._isGroup) {
                contactModel._nickName = [sessionDict im_valueStringForKey:d_nickName];
            }
        } else {
            contactModel._info = baseModel._content;
        }
        contactModel._lastMsg = [dictMsg mj_JSONString];
        contactModel._lastMsgModel = baseModel;
        contactModel._countUnread = [[sessionDict im_valueNumberForKey:d_count] integerValue];
        contactModel._lastMsgId = baseModel._msgId;
        contactModel._muteNotification = [[sessionDict im_valueNumberForKey:d_muteNotification] integerValue];
        contactModel._headPic = [sessionDict im_valueStringForKey:@"avatar"];
        contactModel._tag = [sessionDict im_valueStringForKey:d_tag];
        
        if ([contactModel._target length] == 0) {
            continue;
        }
        
        [response.arrContactModel addObject:contactModel];
    }
    
    NSMutableArray *removeContactSessions = [NSMutableArray new];
    NSArray *deleteSessions = [data im_valueArrayForKey:d_removeSessions];
    for (NSDictionary *deleteSession in deleteSessions) {
        if (!deleteSession) continue;
        
        NSString *sessionName = [deleteSession im_valueStringForKey:@"sessionName"];
        if ([sessionName length]) {
            [removeContactSessions addObject:sessionName];
        }
    }
    
    response.deleteContactModel = removeContactSessions;
    response.maxMsgId = [[data im_valueNumberForKey:@"msgId"] longLongValue];
    return response;
}
// ------------------ 使用msgId字段获取 ------------------ //
@end