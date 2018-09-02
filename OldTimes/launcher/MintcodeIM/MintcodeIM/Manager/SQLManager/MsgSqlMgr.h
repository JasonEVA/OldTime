//
//  MsgSqlMgr.h
//  PalmDoctorDR
//
//  Created by Remon Lv on 15/5/12.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//  消息数据库管理

#import <Foundation/Foundation.h>
#import "ContactDetailModel+Private.h"
#import "UserProfileModel.h"
#import "MsgDefine.h"
#import "MessageRelationGroupModel.h"
#import "MessageRelationInfoModel.h"

@interface MsgSqlMgr : NSObject

/** 单例
 */
+ (MsgSqlMgr *)share;
//- (void)destroyMyself;

#pragma mark - Insert Data

// 批量事务操作，插入删除，以tag区分
/** 插入,array(MessageBaseModel)
 */
- (BOOL)insertBatchData:(NSArray *)array WithTag:(MsgTableTag)tag;
//与前者几本相同，只是判断是否存在的条件加了msgid
- (BOOL)insertrBatchReceivedData:(NSArray *)array WithTag:(MsgTableTag)tag;
// 批量插入会话表数据 批量事务操作
- (BOOL)insertMessageListBatchData:(NSArray *)array WithTag:(MsgTableTag)tag;

/** 将新消息、离线消息封装成需要显示在消息列表上的样子写入到联系人表（没有就插入，有就更新）,需要返回信息是否完整 —— 注意：此方法不能用于任何插入或者更改联系人的用途，只为消息标记服务
 */
- (void)writeMessageListInfoToContactTableWith:(ContactDetailModel *)contactDetailModel;

/**
 *  向用户信息表更新用户信息,没有则插入
 *
 *  @param array UserProfileModel
 */
- (void)updateContactInfoToContactTable:(NSArray *)array;
/// 更新免打扰
- (void)updateMuteNotificationWithModel:(ContactDetailModel *)model;
/// 更新草稿
- (void)updateDraftWithTarget:(NSString *)target draft:(NSAttributedString *)draft;
/// 更新@信息
- (void)updateAtMeWithTarget:(NSString *)target atMe:(BOOL)atMe;
#pragma mark - Update Data

/** 发送消息收到回执修改数据(MessageBaseModel)
 */
- (void)updateSendMessageSuccessWithBaseModel:(MessageBaseModel *)model;

/**
 *  收到撤回消息更新数据
 */
- (void)updateReSendMessageWithbaseModel:(MessageBaseModel *)model;

/** 标记联系人列表中某个联系人未读条数为0（消息列表点击时候的操作）
 */
- (void)markMessageListReadedWithUid:(NSString *)uid;

/** 标记某个联系人的消息已读(文字图片)等
 */
- (void)markMessageReadedWithUid:(NSString *)uid;

/** 通过 Sid 修改或者删除消息状态表的数据，并且返回 Target
 */
- (NSString *)updateMessageStatusWithBaseModel:(MessageBaseModel *)baseModel Status:(Msg_status)msgStatus;

/** 标记消息状态表所有正在发送的消息为发送失败
 */
- (void)markMessageStatusSendingToFailed;

/**
 *  标记正在上传的状态为发送失败
 *
 */
- (void)markMessageStatusWaitingToFailed:(MessageBaseModel *)baseModel;

/** 标记语音消息为已读
 */
- (void)markVoiceMessageReadedWithSqlId:(NSInteger)sqlId;

/** 标记消息为已读
 */
- (void)markMessageReadedWithArrMsgId:(NSArray *)arrMsgId;

/**
 *  标记消息为重点
 *
 */
- (void)markMessageImportantWithMsgId:(long long)MsgId important:(BOOL)isImportant;

/**
 *  标记发送失败的语音和图片为waiting
 *
 */
- (void)markMessageStatusToWaitingWithModel:(MessageBaseModel *)baseModel;


#pragma mark - Query Data

/** 查询消息列表的数据(MessageListModel)
 */
- (NSArray *)queryMessageListDataOnlyChat:(BOOL)onlyChat;

- (NSArray *)queryGroupList;

/**
 *  查询某个对象的会话
 *
 *  @param uid 对象标识符
 */
- (ContactDetailModel *)querySessionDataWithUid:(NSString *)uid;

/** 查询某个人的一批消息(从最新按时间逆序的若干条数据)
 */
- (NSArray *)queryBatchMessageWithAnotherName:(NSString *)anotherName MessageCount:(NSInteger)count;

/** 查询消息表里是否有某条消息的（同时匹配fromLoginName和clientMsgId）
 */
- (BOOL)queryMessageIsExsitWithBaseModel:(MessageBaseModel *)baseModel;

/**
 *  查询消息表里 的某条消息是否与同步的状态一致 (标记重点状态)
 */
- (BOOL)queryMessageIsImportantWithBaseModel:(MessageBaseModel *)baseModel;
/**
 *  查询某个人是否是某群的群成员
 *  @param userName 群名称
 *  @param UID      此人的UID
 */
- (BOOL)queryPeopleIsGroupMembersWithGroupUserName:(NSString *)userName Show_ID:(NSString *)Show_ID;
/*
 * 查询某个会话中 ,缓存中的最新的消息是不是数据库中最新的
 * @param tager 会话唯一标示符 ,会话名称
 * @param 最新消息的msgid
 *
 */
- (BOOL)queryMessageIsNewestWithTagert:(NSString *)tager msgid:(long long)msgid;

/**
 *  查询用户信息是否更改
 *
 *  @param target 用户uid
 *
 *  @return modified
 */
- (long long)queryUserProfileModified:(NSString *)target;

/**
 *  查询总的未读消息条数
 *
 *  @return 未读条数
 */
- (NSInteger)queryAllUnreadMessageCount;

/**
 *  查询不包含某会话的未读消息条数
 *
 *  @param uid 不包含的uid
 *
 *  @return NSInteger
 */
- (NSInteger)queryUnreadMessageCountWithoutUid:(NSString *)uid;

/**
 *  查询一个联系人/群的信息
 *
 *  @param uid 联系人唯一标识符
 *
 *  @return 用户信息
 */
- (UserProfileModel *)queryContactProfileWithUid:(NSString *)uid;

/**
 *  查询一个联系人的信息
 *
 *  @param nickName 联系人昵称(群聊时通过nickName获得该人的信息)
 *
 *  @return 用户信息
 */
- (UserProfileModel *)queryContactProfileWithNickName:(NSString *)nickName;

/**
 *  全局搜索的数据查询
 *
 *  @param keyword 关键词
 *
 *  @return 搜索结果
 */
- (NSArray *)querySearchMessageListWithKeyword:(NSString *)keyword;

/**
 *  查询一个联系人/群的所有未读信息
 *
 *  @param uid 联系人唯一标识符 msgId 分批查询 查询大于该msgId的消息未读的数组
 *
 *  @return 用户信息msgId数组(NSString)格式
 */
- (NSArray *)queryAllUnReadedMessageListWithUid:(NSString *)uid msgId:(long long)msgId;

/**
 *  单个聊天信息搜索
 *
 *  @param keyword 关键词
 *  @param uid     对象
 *
 *  @return 搜索结果
 */
- (NSArray *)querySearchMessageListWithKeyword:(NSString *)keyword uid:(NSString *)uid;

/**
 *  从某一条信息开始查找之前的历史，包含这条数据
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
- (NSArray *)queryOlderMessageHistoryFromSqlID:(long long)sqlID count:(NSInteger)count uid:(NSString *)uid;

/**
 *  从某一条信息开始查找之后的历史，包含这条数据
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
- (NSArray *)queryNewerMessageHistoryFromSqlID:(long long)sqlID count:(NSInteger)count uid:(NSString *)uid;
/**
 *  从某一条信息开始查找之后的历史，包含这条数据  --> Event
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
- (NSArray *)queryNewerEventMessageHistoryFromCreatDate:(long long)creatDate count:(NSInteger)count uid:(NSString *)uid;
/**
 *  从某一条信息开始查找之前的历史，包含这条数据  --> Event
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
- (NSArray *)queryOlderEvevtMessageHistoryFromCreatDate:(long long)creatDate count:(NSInteger)count uid:(NSString *)uid;

/**
 *  查询此列表中,被at的数据
 *
 *  @param target 此聊天(群聊或单聊)的ID
 *  @return 查询到的数据数组
 */

- (NSArray *)queryAtMeMessageFromTarget:(NSString *)target;

/**
 *  查询此列表中,所有图片
 *
 *  @param target 此聊天(群聊或单聊)的ID
 *  @return 查询到的数据数组
 */
- (NSArray *)queryAllImageMessageFromUid:(NSString *)uid;

/**
 *  单个聊天信息查询 --> 图片 OR 文件
 *
 *  @param target     聊天ID
 *
 *  @return 查询结果
 */
- (NSArray *)queryImportantImageMessageFromTarget:(NSString *)target msg_type:(Msg_type)type;
/**
 *  单个聊天信息查询 --> 被标记为重点
 *
 *  @param target     聊天ID
 *
 *  @return 查询结果
 */
- (NSArray *)queryImportantFileAndTextMessageFromTarget:(NSString *)target;
/**
 *  单个聊天信息查询 --> 应用
 *
 *  @param target     聊天ID
 *
 *  @return 查询结果
 */
- (NSArray *)queryAppMessageWithTarget:(NSString *)target;

/**
 *  查询此列表中,所有正在发送的消息
 *
 *  @param
 *  @return 查询到的数据数组
 */
- (NSArray *)queryAllSendingMessage;

#pragma mark - Delete Data

/**
 *  删除一条数据
 *
 */
- (void)deleteMessageWithModel:(MessageBaseModel *)baseModel;

/** 清理表
 */
- (void)deleteTable:(MsgTableTag)tag;

/** 清理某个聊天对象的消息记录（删除消息记录时操作，清除消息内容，清除消息列表）
 */
- (void)deleteMessageListWith:(NSString *)target;

/**
 *  删除不包含数组中的数据
 *
 *  @param array contactDetailModel
 */
- (void)deleteSessionsExcludeSession:(NSArray *)array;

/** 清理某个聊天对象的消息记录（清空消息记录记录时操作，只清除消息列表内容和消息总表的消息，不清除消息列表）
 */
- (void)deleteMessageRecordsWith:(NSString *)target;

#pragma mark - 好友关系 Relation
/**
 *  批量插入好友分组
 *
 *   @param array <MessageRelationGroupModel>
 */
- (void)insertRelationGroupWithArray:(NSArray *)array;
/**
 * 批量插入好友信息
 *
 *  @param array <MessageRelationInfoModel>
 */
- (void)insertRelationInfoWithArray:(NSArray *)array;
/**
 * 删除好友分组
 *
 * @param  relationGroupId 好友分组id
 */
- (void)deleteRelationGroupWithRelationGroupId:(long)relationGroupId;
/**
 *  删除好友
 *
 *  @param  relationName 好友用户名
 */
- (void)deleteRelationInfoWithRelationName:(NSString *)relationName;
/**
 *  修改好友分组
 *
 *  @param relationGroup  MessageRelationGroupModel
 */
- (void)updateRelationGroup:(MessageRelationGroupModel *)relationGroup;
/**
 *  修改好友信息
 *
 *  @param  relationInfo 好友MessageRelationInfoModel名
 */
- (void)updateRelationInfo:(MessageRelationInfoModel *)relationInfo;
/**
 *  获取所有好友分组
 *
 *  @return  @[MessageRelationGroupModel_objs]
 */
- (NSArray *)queryRelationGroups;

/**
 *  获取某分组下的所有好友
 *
 *  @param  relationGroupId 好友分组id
 *  @return  @[MessageRelationInfoModel_objs]
 */
- (NSArray *)queryRelationInfoWithRelationGroup:(long)relationGroupId;

/**
 *  查看某个分组下是否有这个好友
 *
 *  @param relationGroupId 好友分组ID
 *  @param relationName    好友用户名
 */
- (BOOL)queryRelationInfoWithRelationGroup:(long)relationGroupId relationName:(NSString *)relationName;
/**
 *  获取好友列表中对应的好友
 *
 *  @param relationName 好友用户名
 */
- (MessageRelationInfoModel *)queryRelationInfoWithRelationName:(NSString *)relationName;
/**
 *  好友搜索，获取对应的好友数据
 *
 *  @param nickName 好友用户名
 *  @param remark   好友备注
 *
 */
- (NSArray *)queryRelationInfoWithName:(NSString *)nickName remark:(NSString *)remark;

@end
