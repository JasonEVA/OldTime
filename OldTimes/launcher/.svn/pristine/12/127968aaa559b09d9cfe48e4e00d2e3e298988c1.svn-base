//
//  MessageBaseModel.m
//  Titans
//
//  Created by Remon Lv on 14-9-1.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "MessageBaseModel.h"
#import "MessageBaseModel+Private.h"
#import <MJExtension/MJExtension.h>
#import "NSDate+IMManager.h"
#import "ContactDetailModel.h"
#import "MsgUserInfoMgr.h"
#import "ASJSONKitManager.h"
#import "NSDictionary+IMSafeManager.h"
#import "IMApplicationManager.h"
#import "MsgDefine.h"
//#import "MessageBaseContentModel.h"
static NSString * const person_nickName    = @"nickName";
static NSString * const person_userName    = @"userName";

static NSString * const data               = @"data";

@implementation MessageBaseModel

- (BOOL)isEventType {
    return self._type > msg_personal_event && self._type < msg_usefulMsgMax;
}

#pragma mark - 消息类型数据处理

// 附件。 网络图片/音频/视频/文件
- (MessageAttachmentModel *)attachModel {
    if (!_attachModel) {
        _attachModel = [MessageAttachmentModel mj_objectWithKeyValues:self._content];
    }
    return _attachModel;
}

// 消息应用model，里面包含不同的model
- (MessageAppModel *)appModel {
    if (!_appModel) {
        _appModel = [MessageAppModel mj_objectWithKeyValues:self._content];
    }
    return _appModel;
}

- (MessageVoipModel *)voipModel {
    if (!_voipModel) {
        _voipModel = [MessageVoipModel mj_objectWithKeyValues:self._content];
    }
    return _voipModel;
}

/**
 *  从content里面获得已读msgId
 */
- (long long)getMsgId {
    NSDictionary *dictContent = [self._content mt_im_objectFromJSONString];
    long long msgId = [[dictContent im_valueNumberForKey:data] longLongValue];
    return msgId;
}

// 从content里面拿撤回重发消息的type
- (Msg_type)getResendMessageType{
    NSDictionary *dictContent = [self._content mt_im_objectFromJSONString];
    NSString *type = [dictContent im_valueStringForKey:@"type"];
    return [MessageBaseModel getMsgTypeFromString:type];
}

/** 从content中提取新的baseModel */ //---不知是否可以再用
- (MessageBaseModel *)getContentBaseModel {
    NSDictionary *dictContent = [self._content mt_im_objectFromJSONString];
    MessageBaseModel *baseModel = [[MessageBaseModel alloc] initWithDict:dictContent];
    return baseModel;
}

//- (MessageBaseContentModel *)getContentBaseModelV2
//{
//    NSDictionary *dict = [self._content mt_im_objectFromJSONString];
//    MessageBaseContentModel *contentModel = [[MessageBaseContentModel alloc] initWithContentDict:dict];
//    return contentModel;
//}

#pragma mark - Private Method
+ (NSDictionary *)msgTypeDictionary {
    return @{
             // Mgr
             @"Login":@(msg_manager_login),
             @"LoginIn":@(msg_manager_loginIn),
             @"LoginOut":@(msg_manager_loginOut),
             @"LoginKeep":@(msg_manager_loginKeep),
             
             // Data
             @"Rev":@(msg_manager_rev),
             @"Text":@(msg_personal_text),
             @"Audio":@( msg_personal_voice),
             @"Image":@(msg_personal_image),
             @"Video":@(msg_personal_video),
             @"File":@(msg_personal_file),
             @"Alert":@(msg_personal_alert),
             @"Clear":@(msg_cmd_clear),
             @"Read":@(msg_cmd_read),
             @"Event":@(msg_personal_event),
             @"Cmd":@(msg_cmd_cmd),
             @"Open":@(msg_cmd_open),
             @"Mark":@(msg_cmd_mark),
             @"CancelMark":@(msg_cmd_cancelMark),
             @"Remove":@(msg_cmd_remove),
             @"ReSend":@(msg_personal_reSend),
             @"Relation":@(msg_cmd_relation),
             @"MergeMessage":@(msg_personal_mergeMessage),
             @"Voip":@(msg_personal_voip)
             };
}
+ (Msg_type)getMsgTypeFromString:(NSString *)strType
{
    if ([strType hasSuffix:@"@APP"]) {
        NSInteger type = [IMApplicationManager applicationTypeFromUid:strType];
        return type == -1 ? 0 : type;
    }
    
    NSNumber *number = [[self msgTypeDictionary] objectForKey:strType];
    if (!number) {
        return 0;
    }
    return [number integerValue];
}

+ (NSString *)getStringFromMsgType:(Msg_type)msgType
{
    if (msgType > msg_personal_event && msgType < msg_usefulMsgMax) { return @"Event"; }
    
    switch (msgType) {
        case msg_manager_login:         return @"Login";
        case msg_manager_loginIn:       return @"LoginIn";
        case msg_manager_loginOut:      return @"LoginOut";
        case msg_manager_loginKeep:     return @"LoginKeep";
        case msg_manager_rev:           return @"Rev";
        case msg_personal_text:         return @"Text";
        case msg_personal_voice:        return @"Audio";
        case msg_personal_image:        return @"Image";
        case msg_personal_video:        return @"Video";
        case msg_personal_file:         return @"File";
        case msg_personal_alert:        return @"Alert";
        case msg_personal_modified:     return @"UserModified";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wswitch"
        case msg_cmd_clear:             return @"Clear";
#pragma clang diagnostic pop
        case msg_personal_event:        return @"Event";
        case msg_personal_mergeMessage: return @"MergeMessage";
        case msg_personal_voip:         return @"Voip";
        default:                        return nil;
    }
}

// 为时间间隔做初始化
- (id)initWithTimeStamp:(long long)timeStamp
{
    if (self = [super init])
    {
        self._content = [NSDate wzim_dateFormaterWithTimeInterval:timeStamp showWeek:YES appendMinute:YES];
        self._createDate = timeStamp;
        self._type = msg_other_timeStamp;
    }
    return self;
}

// 获得昵称
- (NSString *)getNickName
{
    NSString *nickName = @"";
    NSDictionary *dict = [self._info mt_im_objectFromJSONString];
    if (dict[person_nickName] != [NSNull null] && dict[person_nickName] != nil)
    {
        nickName = dict[person_nickName];
    }
    
    return nickName;
}

//从info获得UserName 群聊消息知道发送者的uid
- (NSString *)getUserName
{
    NSString *userName = @"";
    NSDictionary *dict = [self._info mt_im_objectFromJSONString];
    if (dict[person_userName] != [NSNull null] && dict[person_userName] != nil)
    {
        userName = dict[person_userName];
    }
    return userName;
}

- (NSArray *)atUser {
    NSDictionary *infoDict = [self._info mt_im_objectFromJSONString];
    NSArray *array = [infoDict im_valueArrayForKey:@"atUsers"];
    if (![array isKindOfClass:[NSArray class]]) {
        return @[];
    }
    return array;
}

- (void)getForwardMessagesCompletion:(void (^)(NSArray<MessageBaseModel *> *, NSString *))completion {
    if (!completion) return;
    
    NSDictionary *contentDict = [self._content mt_im_objectFromJSONString];
    NSArray *msgsDicts = contentDict[@"msg"];
    NSMutableArray *msgArray = [NSMutableArray array];
    for (NSDictionary *msgDict in msgsDicts) {
        MessageBaseModel *model = [[MessageBaseModel alloc] initWithDict:msgDict];
        [msgArray addObject:model];
    }
    
    NSString *title = contentDict[@"title"] ?: @"";
    completion(msgArray, title);
}

//- (Msg_type)getAppType {
//    
//    NSLog(@"Target: ==  %@, eventType: ==  %d",self._target, self.appModel.eventType);
//    
//    if (![self._target hasSuffix:@"@APP"]) {
//        self._target = [self._target stringByAppendingString:@"@APP"];
//    }
//    
//    NSInteger type = [IMApplicationManager applicationTypeFromUid:self._target];
//    if (type == -1) {
//        return msg_usefulMsgMin;
//    }
//    
//    return type;
//}

#pragma mark - Audio Manager

#define DICT_fileUrl        @"fileUrl"
#define DICT_AudioLength    @"audioLength"

/**
 *  判断文件资源是否已经下载到位
 *
 *  @return YES/NO
 */
- (BOOL)isFileDownloaded
{
    if (self._nativeOriginalUrl.length > 0 && self._nativeThumbnailUrl.length > 0 )
    {
        return YES;
    }
    return NO;
}

@end
