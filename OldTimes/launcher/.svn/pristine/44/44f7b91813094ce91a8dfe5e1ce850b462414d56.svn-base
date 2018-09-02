//
//  MessageBaseModel+Private.m
//  MintcodeIM
//
//  Created by williamzhang on 16/3/24.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MessageBaseModel+Private.h"
#import "NSDictionary+IMSafeManager.h"
#import "ASJSONKitManager.h"
#import "MsgUserInfoMgr.h"
#import "MsgDefine.h"

#define DICT_from  @"from"
#define DICT_to    @"to"
#define DICT_memberList     @"memberList"
#define DICT_content        @"content"
#define DICT_clientMsgId    @"clientMsgId"
#define DICT_msgId          @"msgId"
#define DICT_info           @"info"
#define DICT_createDate     @"createDate"
#define DICT_type           @"type"
#define DICT_modified       @"modified"

#define DICT_appName        @"appName"
#define DICT_userName       @"userName"
#define DICT_modified       @"modified"
#define DICT_nickName       @"nickName"

static NSString * const content_name       = @"name";

@implementation MessageBaseModel (Private)

// 从服务器初始化(离线消息、接收的消息)
- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (dict != nil)
        {
            self._fromLoginName = @"";
            if ([dict objectForKey:DICT_from] != [NSNull null] && [dict objectForKey:DICT_from] != NULL)
            {
                self._fromLoginName = [dict objectForKey:DICT_from];
            }
            
            self._toLoginName = @"";
            if ([dict objectForKey:DICT_to] != [NSNull null] && [dict objectForKey:DICT_to] != NULL)
            {
                self._toLoginName = [dict objectForKey:DICT_to];
            }
            
            self._content = @"";
            if ([dict objectForKey:DICT_content] != [NSNull null] && [dict objectForKey:DICT_content] != NULL)
            {
                self._content = [dict objectForKey:DICT_content];
            }
            
            if ([dict objectForKey:DICT_clientMsgId] != [NSNull null] && [dict objectForKey:DICT_clientMsgId] != NULL)
            {
                self._clientMsgId = [[dict objectForKey:DICT_clientMsgId] longLongValue];
            }
            
            if ([dict objectForKey:DICT_msgId] != [NSNull null] && [dict objectForKey:DICT_msgId] != NULL)
            {
                self._msgId = [[dict objectForKey:DICT_msgId] longLongValue];
            }
            
            self._info = @"";
            if ([dict objectForKey:DICT_info] != [NSNull null] && [dict objectForKey:DICT_info] != NULL)
            {
                self._info = [dict objectForKey:DICT_info];
            }
            
            if ([dict objectForKey:DICT_createDate] != [NSNull null] && [dict objectForKey:DICT_createDate] != NULL)
            {
                self._createDate = [[dict objectForKey:DICT_createDate] longLongValue];
            }
            
            if ([dict objectForKey:DICT_type] != [NSNull null] && [dict objectForKey:DICT_type] != NULL)
            {
                NSString *strTmp = [dict objectForKey:DICT_type];
                self._type = [MessageBaseModel getMsgTypeFromString:strTmp];
                
                // _type没有clear指令，服务器留下的坑
                if (self._type == msg_cmd_clear) {
                    self._type = msg_usefulMsgMin;
                }
                // 应用消息类型从content里取
                if (self._type == msg_personal_event)
                {
                    self._type = self.appModel.eventType;

                    if (self._type == msg_usefulMsgMin) {
                        self._type = msg_personal_event;
                    }
                }
                else if (self._type == msg_cmd_cmd)
                {
                    // 获得系统消息通知
                    self._type = [self getSystemMessageType];
                }
            }
            
            if ([dict objectForKey:DICT_modified] != [NSNull null] && [dict objectForKey:DICT_modified] != NULL)
            {
                self._modified = [[dict objectForKey:DICT_modified] longLongValue];
            }
            self._nativeOriginalUrl = @"";
            self._nativeThumbnailUrl = @"";
            // 其它标记
            self._markFromReceive = NO;
            if (self._type == msg_cmd_read)
            {
                self._markReaded = YES;
            }
            else
            {
                self._markReaded = NO;
            }
            self._markStatus = status_send_success;
            
            NSString *selfName = [[MsgUserInfoMgr share] getUid];
            // 信息是由服务器发送过来的，所以Target即为fromLoginName
            if ([self._fromLoginName isEqualToString:selfName])
            {
                self._target = self._toLoginName;
            }
            else
            {
                self._target = self._fromLoginName;
                self._markFromReceive = YES;
            }
            
            self._markImportant = [dict im_valueBoolForKey:@"bookMark"];
        }
    }
    return self;
}


// 为发送消息做初始化
- (id)initWithMsgId:(long long)msgId From:(NSString *)fromName To:(NSString *)toName Info:(NSString *)info Content:(NSString *)content MemberList:(NSString *)memberList Cid:(long long)cid CreateDate:(long long)createDate Type:(Msg_type)type
{
    if (self = [super init])
    {
        self._fromLoginName = fromName;
        self._toLoginName = toName;
        self._target = toName;
        self._markFromReceive = NO;
        self._msgId = msgId;
        self._info = info;
        self._content = content;
        self._clientMsgId = cid;
        self._createDate = createDate;
        self._type = type;
    }
    return self;
}

#pragma mark - Private Method
// 从content里面拿系统指令  Read，Open，Clear
- (Msg_type)getSystemMessageType {
    NSDictionary *dictContent = [self._content mt_im_objectFromJSONString];
    NSString *type = [dictContent im_valueStringForKey:content_name];
    return [MessageBaseModel getMsgTypeFromString:type];
}

@end
