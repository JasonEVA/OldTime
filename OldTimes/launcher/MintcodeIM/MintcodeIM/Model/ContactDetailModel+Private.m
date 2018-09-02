//
//  ContactDetailModel+Private.m
//  MintcodeIM
//
//  Created by williamzhang on 16/3/24.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ContactDetailModel+Private.h"
#import "NSDictionary+IMSafeManager.h"
#import "ASJSONKitManager.h"

@interface NSString (ContactDetailModelPrivate)

- (NSString *)wz_stringByWrappingInvisibleIdentifiers;

@end

#define WZ_INVISIBLE_IDENTIFIER @"\uFEFF\u200B"

@implementation ContactDetailModel (Private)

static NSString * const d_loginName      = @"loginName";
static NSString * const d_anotherName    = @"anotherName";
static NSString * const d_realName       = @"realName";
static NSString * const d_deptName       = @"deptName";
static NSString * const d_parentDeptName = @"parentDeptName";
static NSString * const d_officePhone    = @"officePhone";
static NSString * const d_mobilePhone    = @"mobilePhone";
static NSString * const d_headPic        = @"headPic";
static NSString * const d_position       = @"position";
static NSString * const d_userMail       = @"userMail";
static NSString * const d_modified       = @"modified";

static NSString * const s_size_56   = @"56x56";
static NSString * const s_size_80   = @"80x80";
static NSString * const s_size_200  = @"200x200";

static NSString * const d_nickName    = @"nickName";
static NSString * const d_groupName   = @"groupName";
static NSString * const d_sessionName = @"sessionName";

static NSString * const d_content  = @"content";
static NSString * const d_msgTitle = @"msgTitle";

- (id)initWithMessageBaseModel:(MessageBaseModel *)baseModel
{
    if (self = [super init])
    {
        if (baseModel._type >= msg_usefulMsgMax)
        {
            return self;
        }
        
        // 对聊天消息进行审查
        NSString *strContent = @"";
        // target
        self._target = baseModel._target;
        
        switch (baseModel._type) {
            case msg_personal_text:
            case msg_personal_alert:        strContent = baseModel._content; break;
            case msg_personal_image:        strContent = [wz_image_type wz_stringByWrappingInvisibleIdentifiers]; break;
            case msg_personal_voice:        strContent = [wz_voice_type wz_stringByWrappingInvisibleIdentifiers]; break;
            case msg_personal_video:        strContent = [wz_viedo_type wz_stringByWrappingInvisibleIdentifiers]; break;
            case msg_personal_file:         strContent = [wz_file_type wz_stringByWrappingInvisibleIdentifiers];  break;
            case msg_personal_mergeMessage: strContent = [wz_mergetForward_type wz_stringByWrappingInvisibleIdentifiers]; break;
                
            case msg_personal_reSend:{
                MessageBaseModel *newBaseModel = [baseModel getContentBaseModel];
                strContent = newBaseModel._content;
            }
                break;
                
            case msg_personal_voip: {
                MessageVoipModel *voipModel = baseModel.voipModel;
                
                if (voipModel.state <= MTVoipStateVideoFinish) {
                    strContent = [wz_viedoVoip_type wz_stringByWrappingInvisibleIdentifiers];
                }
                else {
                    strContent = [wz_voiceVoip_type wz_stringByWrappingInvisibleIdentifiers];
                }
                
            }
                break;
            default:break;
                
        }
        
        // 这里需要>=
        if (baseModel._type >= msg_personal_event && baseModel._type < msg_usefulMsgMax) {
            NSDictionary *dictInfo = [baseModel._content mt_im_objectFromJSONString];
            strContent = [dictInfo im_valueStringForKey:d_msgTitle];
            Msg_type appType = [MessageBaseModel getMsgTypeFromString:baseModel._fromLoginName];
            self._isApp = appType >= msg_personal_event && appType < msg_usefulMsgMax;
        }
        
        self._isGroup = [ContactDetailModel isGroupWithTarget:self._target];
        
        // 内容
        if (self._isGroup && baseModel._type != msg_personal_alert && ![baseModel isEventType])
        {
            NSString *nickName = [baseModel getNickName];
            self._content = [NSString stringWithFormat:@"%@:%@",nickName,strContent];
        }
        else
        {
            self._content = strContent;
        }
        
        if (self._isGroup && baseModel._type == msg_personal_reSend && [baseModel getContentBaseModel]._type == msg_personal_alert) {
            self._content = strContent;
        }
        
        // nickName
        NSDictionary *dictInfo = [baseModel._info mt_im_objectFromJSONString];
        
        // 需要显示在应用列表上的
        if (self._isApp) {
            // 啥都可以不用做
        }
        else if ([self isRelationSystem]) {
            self._nickName = @"好友验证";
        }
        else if (!self._isGroup)
        {
            self._nickName = [dictInfo objectForKey:d_nickName];
        }
        else
        {
            self._nickName = [dictInfo objectForKey:d_sessionName];
        }
        
        self._countUnread = 0;
        
        // 系统提示消息无需加1
        if (baseModel._markReaded == NO && baseModel._type != msg_personal_alert && baseModel._type != msg_personal_reSend)
        {
            // 默认是新增一条
            if (baseModel._markFromReceive)
            {
                self._countUnread = 1;
            }
        }
        
        // 时间戳
        self._timeStamp = baseModel._createDate;
        self._modified  = baseModel._modified;
        self._info      = baseModel._info;
        self._lastMsgId = baseModel._msgId;
        self._lastMsg   = baseModel.lastMsg;
    }
    return self;
}

@end

@implementation NSString (ContactDetailModelPrivate)

- (NSString *)wz_stringByWrappingInvisibleIdentifiers {
    return [NSString stringWithFormat:@"%@%@%@", WZ_INVISIBLE_IDENTIFIER,self,WZ_INVISIBLE_IDENTIFIER];
}

@end
