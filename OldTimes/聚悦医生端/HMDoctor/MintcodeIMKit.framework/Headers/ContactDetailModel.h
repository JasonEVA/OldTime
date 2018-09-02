//
//  ContactDetailModel.h
//  launcher
//
//  Created by William Zhang on 15/8/14.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

//  联系人详情model

#import <Foundation/Foundation.h>
#import "IMEnum.h"

@class MessageBaseModel;

// 若需要进行翻译，先使用｀verifyType:进行判断，然后进行替换
extern NSString * const wz_image_type;
extern NSString * const wz_voice_type;
extern NSString * const wz_viedo_type;
extern NSString * const wz_file_type;
extern NSString * const wz_mergetForward_type;
extern NSString * const wz_voiceVoip_type;
extern NSString * const wz_viedoVoip_type;
extern NSString * const wz_news_type;


extern NSString * const d_nickName;
extern NSString * const d_groupName;
extern NSString * const d_sessionName;
extern NSString * const d_content;
extern NSString * const d_msgTitle;
extern NSString * const d_tag; // 会话tag
extern NSString * const d_score; // 会话权重


@interface ContactDetailModel : NSObject

@property (nonatomic, assign) NSInteger _sqlId;             // sqlId
@property (nonatomic, strong) NSString  *_headPic;          // 头像名

@property (nonatomic, assign) long long _modified;          // 用户最后更新时间
@property (nonatomic, assign) BOOL      _isApp;             // 是否是App模式
@property (nonatomic, strong) NSString  *_extension;        // JSON扩展备用

// 消息回来
@property (nonatomic,strong) NSString *_target;              // 登录账号
@property (nonatomic,strong) NSString *_nickName;            // 真实姓名
@property (nonatomic) BOOL _isGroup;                         // 是不是群

@property (nonatomic, strong) NSString *_content;       // 消息内容
@property (nonatomic, assign) NSInteger _countUnread;   // 未读消息条数
@property (nonatomic, assign) long long _timeStamp;     // 时间戳
@property (nonatomic) long long _lastMsgId;             // 最后一条消息msgId 用于判断是否需要拉取历史消息
@property(nonatomic, copy) NSString  *_lastMsg;                 //lastMsg的JSon字符串
@property(nonatomic, strong) MessageBaseModel  *_lastMsgModel;  // lastMsg内容转化的Modle
@property (nonatomic, copy) NSString *_info;
@property (nonatomic, assign) NSInteger _muteNotification;
/// 草稿
@property (nonatomic, strong) NSAttributedString *_draft;
@property (nonatomic, assign) BOOL _atMe;
/// 群组标签 若为群组则可以有标签
@property (nonatomic, copy) NSString *_tag;

@property (nonatomic) long long _score;             // 权重
@property (nonatomic, assign) NSInteger _stick;   // 会话置顶标示 1 为置顶 0为非置顶
@property (nonatomic, assign) NSInteger _chatStatus;   // 会话状态 0为普通状态 1为发送回执消息状态

/** 判断是不是群聊 */
+ (BOOL)isGroupWithTarget:(NSString *)target;

/// 从info中提取atUser
- (NSArray *)atUser;
/// 判断info中有没有@我
- (BOOL)isAtMe;
/// 从info中提取当前是谁发送的信息
- (NSString *)getUid;
/// 是否是好友分组系统
- (BOOL)isRelationSystem;
/**
 *  用于比较是否为相应类型
 *
 *  @param type 图片，语音，附件，视频
 *
 *  @return 是否为相应类型
 */
- (BOOL)verifyType:(Msg_type)type;

@end
