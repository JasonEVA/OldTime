//
//  MessageTable.h
//  launcher
//
//  Created by Andrew Shen on 15/9/24.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMEnum.h"

@class FMDatabase;
@class MessageBaseModel;

extern NSString *const kTableMessage;

@interface MessageTable : NSObject

/**
 *  创建表
 */
+ (void)createMessageTableWithDB:(FMDatabase *)db;

#pragma mark - Update
/**
 *  插入消息
 *
 *  @param db    db
 *  @param array 消息数组
 *
 */
+ (void)insertMessageWithDB:(FMDatabase *)db batchData:(NSArray *)array;

//加入msgID判断是否有数据
+ (void)insertReceivedMessageWithDB:(FMDatabase *)db batchData:(NSArray *)array;
/**
 *  发送消息收到回执更新数据
 *
 *  @param db    db
 *  @param model 消息数据
 */
+ (void)updateSendMessageSuccessWithDB:(FMDatabase *)db baseModel:(MessageBaseModel *)model;

/**
 *  收到撤回消息更新数据
 *
 *  @param db    db
 *  @param model 消息数据
 */
+ (BOOL)updateReSendMessageWithDB:(FMDatabase *)db baseModel:(MessageBaseModel *)model;

/**
 *  标记对象的消息为已读
 *
 *  @param db  db
 *  @param uid 对象标识符
 */
+ (void)updateReadedForContactWithDB:(FMDatabase *)db uid:(NSString *)uid;

/**
 *  将对方读过的消息标记
 *
 *  @param db        db
 *  @param msgIDList 已读消息msgID数组,(string)
 */
+ (void)updateSentMessageReadedWithDB:(FMDatabase *)db messageIDList:(NSArray *)msgIDList;

/**
 *  将消息标记重点
 *
 *  @param db        db
 *  @param msgIDList 标记消息msgID,(longlong)
 */
+ (void)updateMarkMessageImportantWithDB:(FMDatabase *)db messageID:(long long)msgID important:(BOOL)isImportant;
 
/**
 *  标记某条消息状态
 *
 *  @param db        db
 *  @param baseModel 消息model
 *  @param msgStatus 消息状态
 *
 *  @return 联系人唯一标识符
 */
+ (NSString *)updateMessageStatusWithDB:(FMDatabase *)db baseModel:(MessageBaseModel *)baseModel status:(Msg_status)msgStatus;

/**
 *  将消息的原有状态为failed
 *
 *  @param db            db
 *  @param originalState 原有状态
 */
+ (void)updateAllMessageOriginalStateToFailedWithDB:(FMDatabase *)db originalStatus:(Msg_status)originalStatus;

/**
 *  将某一条消息的原有状态为failed
 *
 *  @param db            db
 *  @param baseModel 消息model
 *  @param originalState 原有状态
 *  @param newStatus      新状态
 */
+ (void)updateMessageOriginalStateToFailedWithDB:(FMDatabase *)db baseModel:(MessageBaseModel *)baseModel originalStatus:(Msg_status)originalStatus newStatus:(Msg_status)newStatus;

/**
 *  标记语音消息为已读
 *
 *  @param db    db
 *  @param sqlID 语音消息的sqlID
 */
+ (void)updateVoiceMessageReadedWithDB:(FMDatabase *)db sqlID:(NSInteger)sqlID;


#pragma mark - Query
/// 查询对象的最新一条消息
+ (MessageBaseModel *)queryNewestMessageWithDB:(FMDatabase *)db target:(NSString *)target;
/**
 *  查询对象的一批消息,按时间逆序排列
 *
 *  @param db    db
 *  @param uid   对象唯一标识符
 *  @param count 条数
 *
 *  @return 消息数据
 */
+ (NSArray *)queryBatchMessageWithDB:(FMDatabase *)db uid:(NSString *)uid messageCount:(NSInteger)count;
/**
 *  查询对象的一批消息,按时间逆序排列
 *
 *  @param uid         对象唯一标示符号
 *  @param count       条数
 *  @param beforeMsgId 在此条之前
 *
 *  @return 消息数据
 */
+ (NSArray *)queryBatchMessageWithDB:(FMDatabase *)db uid:(NSString *)uid messageCount:(NSInteger)count beforeMsgId:(long long)beforeMsgId;
/**
 *  查询消息表里是否有某条消息的（同时匹配fromLoginName和cid）
 *
 *  @param db        db
 *  @param baseModel 消息model
 *
 *  @return 是否存在
 */
+ (BOOL)queryMessageIsExistWithDB:(FMDatabase *)db baseModel:(MessageBaseModel *)baseModel;
/**
 *  查询消息表里 的某条消息是否与同步的状态一致
 *
 *  @param db        db
 *  @param baseModel 消息model
 *
 *  @return 是否一致
 */
+ (BOOL)queryMessageIsImportantWithDB:(FMDatabase *)db baseModel:(MessageBaseModel *)baseModel;
/* 
 * 查询某个会话中 ,缓存中的最新的消息是不是数据库中最新的
 * @param tagert 会话唯一标示符 ,会话名称
 * @param 最新消息的msgid
 *
 *  @return 是否最新
 */
+  (BOOL)queryMessageIsNewestWithDB:(FMDatabase *)db Tagert:(NSString *)tagert msgid:(long long)msgid;
/**
 *  查询联系人/群的所有未读消息
 *
 *  @param db  db
 *  @param uid 对象唯一标识符 msgId 大于该msgId之前的信息查询
 *
 *  @return 纬度消息msgID数组
 */
+ (NSArray *)queryAllUnreadMessageIDWithDB:(FMDatabase *)db uid:(NSString *)uid msgId:(long long)msgId;

/**
 *  从某一条信息开始查找之前的历史，包含这条数据
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
+ (NSArray *)queryOlderMessageHistoryWithDB:(FMDatabase *)db fromSqlID:(long long)sqlID count:(NSInteger)count uid:(NSString *)uid;
/**
 *  从某一条信息开始查找之后的历史，包含这条数据
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
+ (NSArray *)queryNewerMessageHistoryWithDB:(FMDatabase *)db fromSqlID:(long long)sqlID count:(NSInteger)count uid:(NSString *)uid;
/**
 *  从某一条信息开始查找之后的历史，包含这条数据  --> Event
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
+ (NSArray *)queryNewerEventMessageHistoryWithDB:(FMDatabase *)db fromCreatDate:(long long)creatDate count:(NSInteger)count uid:(NSString *)uid;
/**
 *  从某一条信息开始查找之前的历史，包含这条数据  --> Event
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
+ (NSArray *)queryOlderEvevtMessageHistoryWithDB:(FMDatabase *)db fromCreatDate:(long long)creatDate count:(NSInteger)count uid:(NSString *)uid;

/**
 *  查询此列表中,自己被@的消息
 *
 *  @param target 此聊天(群聊或单聊)的ID
 *  @return 查询到的数据数组
 */
+ (NSArray *)queryAtMeMessageWithDB:(FMDatabase *)db fromTarget:(NSString *)target;

/**
 *  查询此列表中,所有图片
 *
 *  @param target 此聊天(群聊或单聊)的ID
 *  @return 查询到的数据数组
 */
+ (NSArray *)queryAllImageMessageIDWithDB:(FMDatabase *)db uid:(NSString *)uid;

/**
 *  查询列表中带有关键字的数据
 *
 *  @param db      db
 *  @param keyword 关键字
 *
 *  @return 列表中带有关键字的数据
 */
+ (NSArray *)querySearchMessageWithDB:(FMDatabase *)db keyword:(NSString *)keyword;

/**
 *  查询列表中某一对象消息记录中带有关键字的数据
 *
 *  @param db      db
 *  @param keyword 关键字
 *  @param target  对象uid
 *
 *  @return 列表中某一对象消息记录中带有的关键字数据
 */
+ (NSArray *)querySearchMessageWithDB:(FMDatabase *)db keyword:(NSString *)keyword target:(NSString *)target;

/**
 *  查询本地列表中相应type的数据
 *
 *  @param db     db
 *  @param target 对象uid
 *  @param type   相应类型
 *
 *  @return 本地列表中某一对象的相应type数据
 */
+ (NSArray *)queryLocalMessagesWithDB:(FMDatabase *)db target:(NSString *)target msg_type:(Msg_type)type;

/**
 *  查询本地列表中某对象标为重点的数据
 *
 *  @param db     db
 *  @param target 对象uid
 *
 *  @return 本地列表中某一对象标为重点的数据
 */
+ (NSArray *)queryLocalImportantMessagesWithDB:(FMDatabase *)db target:(NSString *)target;

/**
 *  查询此列表中,所有正在发送的消息
 *
 *  @param
 *  @return 查询到的数据数组
 */
+ (NSArray *)queryAllSendingMessageWithDB:(FMDatabase *)db;

#pragma mark - Delete
/**
 *  删除一条信息
 *
 *  @param db        db
 *  @param baseModel 待删model数据
 */
+ (void)deleteMessageWithDB:(FMDatabase *)db baseModel:(MessageBaseModel *)baseModel;

/**
 *  清理某个对象的消息内容
 *
 *  @param db  db
 *  @param uid 对象标识符
 */
+ (void)deleteMessageRecordsWithDB:(FMDatabase *)db uid:(NSString *)uid;

/**
 *  删除表
 *
 */
+ (void)deleteMessageTableWithDB:(FMDatabase *)db;
@end
