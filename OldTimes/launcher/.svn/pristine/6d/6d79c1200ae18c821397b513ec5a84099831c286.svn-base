//
//  MsgSqlMgr.m
//  PalmDoctorDR
//
//  Created by Remon Lv on 15/5/12.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#import "MsgSqlMgr.h"
#import "MsgFilePathMgr.h"
#import "MsgUserInfoMgr.h"
#import "MessageBaseModel.h"
#import "NSString+Manager.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import <MJExtension.h>
#import "MessageSqlVersionManager.h"
#import "MessageTable.h"
#import "MessageListTable.h"
#import "MessageContactsTable.h"
#import "MessageRelationGroupTable.h"
#import "MessageRelationInfoListTable.h"
#import "MessageRelationInfoModel.h"

@interface MsgSqlMgr() {
    FMDatabaseQueue *DBQueue;                  // 数据库管理类（一个用户就建一个数据库）
    NSString *_sqlPath;                 // 公告数据库路径
}


@property (nonatomic, copy) NSString *currentUid;

@end

@implementation MsgSqlMgr

// 单例
+ (MsgSqlMgr *)share
{
    static MsgSqlMgr *msgSqlMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        msgSqlMgr = [[MsgSqlMgr alloc] init];
    });
    
    [msgSqlMgr updateUserAndCreateTables];
    return msgSqlMgr;
}

// 生成路径并创建表
- (void)updateUserAndCreateTables {
    NSString *newUid = [[MsgUserInfoMgr share] getUid];
    if ([newUid isEqualToString:self.currentUid]) {
        // 已经创建过数据库
        return;
    }
    
    if (![newUid length]) {
        return;
    }
    
    // 数据库文件路径 ,创建数据库
    _sqlPath = [NSString stringWithFormat:@"%@/%@.sqlite",[[MsgFilePathMgr share] getSqlPath],[[MsgUserInfoMgr share] getUid]];
    DBQueue = [FMDatabaseQueue databaseQueueWithPath:_sqlPath];
    self.currentUid = newUid;
    // 批量创建数据库和表（自动判断是否存在）
    [self createTables];
}

#pragma mark - Interface Method
// 创建表
- (void)createTables
{
    [DBQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [MessageSqlVersionManager versionUpdateIfNeedInDatabase:db];
        // 创建消息表
        [MessageTable createMessageTableWithDB:db];
        
        // 创建消息列表表
        [MessageListTable createMessageListTableWithDB:db];
        // 创建消息联系人表
        [MessageContactsTable createMessageContactsTableWithDB:db];
        
        [MessageRelationGroupTable createTableWithDB:db];
        
        [MessageRelationInfoListTable createTableWithDB:db];
    }];
    
}

// 批量插入消息数据
- (BOOL)insertBatchData:(NSArray *)array WithTag:(MsgTableTag)tag
{
    __block BOOL isRollback = NO;
    switch (tag) {
        case table_msg:
        {
            [DBQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                [MessageTable insertMessageWithDB:db batchData:array];
                isRollback = *rollback;
            }];
            break;
        }
            
        default:
            break;
    }
    return isRollback;
}


// 批量插入消息数据
- (BOOL)insertrBatchReceivedData:(NSArray *)array WithTag:(MsgTableTag)tag
{
    __block BOOL isRollback = NO;
    switch (tag) {
        case table_msg:
        {
            [DBQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                [MessageTable insertReceivedMessageWithDB:db batchData:array];
                isRollback = *rollback;
            }];
            break;
        }
            
        default:
            break;
    }
    return isRollback;
}


// 批量插入会话表数据
- (BOOL)insertMessageListBatchData:(NSArray *)array WithTag:(MsgTableTag)tag
{
    __block BOOL isRollback = NO;
    switch (tag) {
        case table_msgList:
        {
            [DBQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                [MessageListTable writeToMessageListWithDB:db dataArray:array];
                isRollback = *rollback;
            }];
            break;
        }
            
        default:
            break;
    }
    return isRollback;
}


/**
 *  向用户信息表插入用户信息
 *
 *  @param array UserProfileModel
 */
- (void)updateContactInfoToContactTable:(NSArray *)array
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        UserProfileModel *model = [array firstObject];
        // 更新联系人表
        [MessageContactsTable insertMessageContactsTableWithDB:db batchData:array];
        // 更新聊天列表
        [MessageListTable updateMessageListWithDB:db userProfileModel:model];
        
        // 若为群则存储群成员
        for (UserProfileModel *subModel in model.memberList) {
            [MessageContactsTable insertMessageContactsTableWithDB:db batchData:@[subModel]];
        }
    }];
}

- (void)updateMuteNotificationWithModel:(ContactDetailModel *)model {
    [DBQueue inDatabase:^(FMDatabase *db) {
        [MessageListTable updateNotificationWithDB:db data:model];
    }];
}

/// 更新草稿
- (void)updateDraftWithTarget:(NSString *)target draft:(NSAttributedString *)draft {
    
    [DBQueue inDatabase:^(FMDatabase *db) {
        [MessageListTable updateDraftWithDB:db target:target draft:draft];
    }];
}

/// 更新@信息
- (void)updateAtMeWithTarget:(NSString *)target atMe:(BOOL)atMe {
    [DBQueue inDatabase:^(FMDatabase *db) {
        [MessageListTable updateAtMeWithDB:db target:target atMe:atMe];
    }];
}

// 将新消息、离线消息封装成需要显示在消息列表上的样子写入到会话列表表（没有就插入，有就更新）,需要返回信息是否完整
- (void)writeMessageListInfoToContactTableWith:(ContactDetailModel *)contactDetailModel
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        [MessageListTable writeToMessageListWithDB:db data:contactDetailModel];
    }];
}

/** 发送消息收到回执修改数据(MessageBaseModel)
 */
- (void)updateSendMessageSuccessWithBaseModel:(MessageBaseModel *)model
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        [MessageTable updateSendMessageSuccessWithDB:db baseModel:model];
    }];
}

/**
 *  收到撤回消息更新数据
 */
- (void)updateReSendMessageWithbaseModel:(MessageBaseModel *)model
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        [MessageTable updateReSendMessageWithDB:db baseModel:model];
    }];
}

// 标记一个联系人已读 联系人列表
- (void)markMessageListReadedWithUid:(NSString *)uid;
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        // 标记会话列表
        [MessageListTable updateReadedForMessageListWithDB:db uid:uid];
        
        // 标记消息列表
        //        [MessageTable updateReadedForContactWithDB:db uid:uid];
    }];
}

//标记某个联系人的消息已读(文字图片)等 左边的消息
- (void)markMessageReadedWithUid:(NSString *)uid
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        // 标记会话列表
        [MessageListTable updateReadedForMessageListWithDB:db uid:uid];
        
        // 标记消息列表
        //        [MessageTable updateReadedForContactWithDB:db uid:uid];
    }];
}

// 通过 Sid 修改或者删除消息状态表的数据，并且返回 Target
- (NSString *)updateMessageStatusWithBaseModel:(MessageBaseModel *)baseModel Status:(Msg_status)msgStatus
{
    __block NSString *uid = nil;
    [DBQueue inDatabase:^(FMDatabase *db) {
        uid = [MessageTable updateMessageStatusWithDB:db baseModel:baseModel status:msgStatus];
    }];
    return uid;
}

/** 标记消息状态表所有正在发送的消息为发送失败
 */
- (void)markMessageStatusSendingToFailed
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        [MessageTable updateAllMessageOriginalStateToFailedWithDB:db originalStatus:status_sending];
        [MessageTable updateAllMessageOriginalStateToFailedWithDB:db originalStatus:status_send_waiting];
    }];
}

/**
 *  标记正在上传的状态为发送失败
 *
 */
- (void)markMessageStatusWaitingToFailed:(MessageBaseModel *)baseModel
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        [MessageTable updateMessageOriginalStateToFailedWithDB:db baseModel:baseModel originalStatus:status_send_waiting newStatus:status_send_failed];
    }];
}

/**
 *  标记发送失败的语音和图片为waiting
 *
 */
- (void)markMessageStatusToWaitingWithModel:(MessageBaseModel *)baseModel
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        [MessageTable updateMessageOriginalStateToFailedWithDB:db baseModel:baseModel originalStatus:status_send_failed newStatus:status_send_waiting];
    }];
}

/** 标记语音消息为已读
 */
- (void)markVoiceMessageReadedWithSqlId:(NSInteger)sqlId
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        [MessageTable updateVoiceMessageReadedWithDB:db sqlID:sqlId];
    }];
}


/**
 *  标记消息为重点
 *
 */
- (void)markMessageImportantWithMsgId:(long long)MsgId important:(BOOL)isImportant
{
    [DBQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [MessageTable updateMarkMessageImportantWithDB:db messageID:MsgId important:isImportant];
    }];
}

/** 标记消息为已读
 */
- (void)markMessageReadedWithArrMsgId:(NSArray *)arrMsgId
{
    [DBQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [MessageTable updateSentMessageReadedWithDB:db messageIDList:arrMsgId];
    }];
}
#pragma mark - Query Method
// 查询消息列表的数据(MessageListModel)
- (NSArray *)queryMessageListDataOnlyChat:(BOOL)onlyChat
{
    __block NSArray *arrayMsgList;
    [DBQueue inDatabase:^(FMDatabase *db) {
        //        NSArray *arrAppList = [MessageListTable queryAppMessageListDataWithDB:db];
        NSArray *arrMsgList = [MessageListTable queryMessageListDataWithDB:db onlyChat:onlyChat];
        
        for (ContactDetailModel *model in arrMsgList) {
            // 需要将发送失败的信息更新在列表上以显示最新数据
            MessageBaseModel *newestModel = [MessageTable queryNewestMessageWithDB:db target:model._target];
            if (!newestModel) {
                continue;
            }
            
            if (newestModel._type == msg_personal_reSend)
            {
                continue;
            }
            
            ContactDetailModel *detailModel = [[ContactDetailModel alloc] initWithMessageBaseModel:newestModel];
            if (detailModel._timeStamp < model._timeStamp) {
                // 列表上的数据最新，不更新
                continue;
            }
            
            model._info = detailModel._info;
            model._content = detailModel._content;
            model._timeStamp = detailModel._timeStamp;
        }
        
        arrMsgList = [arrMsgList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 _timeStamp] > [obj2 _timeStamp]) {
                return NSOrderedAscending;
            }
            
            return NSOrderedDescending;
        }];
        
        //        arrayMsgList = [arrAppList arrayByAddingObjectsFromArray:arrMsgList];
        arrayMsgList = arrMsgList;
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return arrayMsgList;
}

- (NSArray *)queryGroupList {
    __block NSArray *groupList;
    [DBQueue inDatabase:^(FMDatabase *db) {
        groupList = [MessageListTable queryGroupListWithDB:db];
        
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    
    return groupList;
}

/**
 *  查询某个对象的会话
 *
 *  @param uid 对象标识符
 */
- (ContactDetailModel *)querySessionDataWithUid:(NSString *)uid {
    __block ContactDetailModel *sessionModel;
    [DBQueue inDatabase:^(FMDatabase *db) {
        sessionModel = [MessageListTable querySessionWithDB:db uid:uid];
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return sessionModel;
    
}
// 查询某个人的一批消息(从最新按时间逆序的若干条数据)
- (NSArray *)queryBatchMessageWithAnotherName:(NSString *)anotherName MessageCount:(NSInteger)count
{
    __block NSArray *arrayMessage;
    [DBQueue inDatabase:^(FMDatabase *db) {
        arrayMessage = [MessageTable queryBatchMessageWithDB:db uid:anotherName messageCount:count];
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return arrayMessage;
}

/**
 *  查询此列表中,所有正在发送的消息
 *
 *  @param
 *  @return 查询到的数据数组
 */
- (NSArray *)queryAllSendingMessage
{
    __block NSArray *arrayMessage;
    [DBQueue inDatabase:^(FMDatabase *db) {
        arrayMessage = [MessageTable queryAllSendingMessageWithDB:db];
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return arrayMessage;
}

/**
 *  全局搜索的数据查询
 *
 *  @param keyword 关键词
 *
 *  @return 搜索结果
 */
- (NSArray *)querySearchMessageListWithKeyword:(NSString *)keyword {
    __block NSArray *arrMsg = [NSArray array];
    [DBQueue inDatabase:^(FMDatabase *db) {
       
        arrMsg = [MessageTable querySearchMessageWithDB:db keyword:keyword];
        
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    
    return arrMsg;
}

/**
 *  单个聊天信息搜索
 *
 *  @param keyword 关键词
 *  @param uid     对象
 *
 *  @return 搜索结果
 */
- (NSArray *)querySearchMessageListWithKeyword:(NSString *)keyword uid:(NSString *)uid {
    __block NSArray *arrMsg = [NSArray array];
    [DBQueue inDatabase:^(FMDatabase *db) {
        arrMsg = [MessageTable querySearchMessageWithDB:db keyword:keyword target:uid];
        
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    
    return arrMsg;
}
/**
 *  单个聊天信息查询 --> 图片 OR 文件
 *
 *  @param target     聊天ID
 *
 *  @return 查询结果
 */
- (NSArray *)queryImportantImageMessageFromTarget:(NSString *)target msg_type:(Msg_type)type
{
    __block  NSArray *arrMsg;
    
    [DBQueue inDatabase:^(FMDatabase *db) {
        
        arrMsg = [MessageTable queryLocalMessagesWithDB:db target:target msg_type:type];
        
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return arrMsg;
}

/**
 *  单个聊天信息查询 --> 应用
 *
 *  @param target     聊天ID
 *
 *  @return 查询结果
 */
- (NSArray *)queryAppMessageWithTarget:(NSString *)target
{
    __block NSArray *arrMsg;
    [DBQueue inDatabase:^(FMDatabase *db) {
        arrMsg = [MessageTable queryLocalMessagesWithDB:db target:target msg_type:msg_personal_event];
        
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return arrMsg;
}

/**
 *  单个聊天信息查询 --> 被标记为重点的消息
 *
 *  @param target     聊天ID
 *
 *  @return 查询结果
 */
- (NSArray *)queryImportantFileAndTextMessageFromTarget:(NSString *)target
{
    __block NSArray *arrMsg;
    [DBQueue inDatabase:^(FMDatabase *db) {
        arrMsg = [MessageTable queryLocalImportantMessagesWithDB:db target:target];
        
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return arrMsg;
}


/**
 *  从某一条信息开始查找之前的历史，包含这条数据
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
- (NSArray *)queryOlderMessageHistoryFromSqlID:(long long)sqlID count:(NSInteger)count uid:(NSString *)uid {
    __block NSArray *arrayMesage;
    [DBQueue inDatabase:^(FMDatabase *db) {
        arrayMesage = [MessageTable queryOlderMessageHistoryWithDB:db fromSqlID:sqlID count:count uid:uid];
    }];
    return arrayMesage;
}

/**
 *  从某一条信息开始查找之后的历史，包含这条数据
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
- (NSArray *)queryNewerMessageHistoryFromSqlID:(long long)sqlID count:(NSInteger)count uid:(NSString *)uid {
    __block NSArray *arrayMesage;
    [DBQueue inDatabase:^(FMDatabase *db) {
        arrayMesage = [MessageTable queryNewerMessageHistoryWithDB:db fromSqlID:sqlID count:count uid:uid];
    }];
    return arrayMesage;
    
}
/**
 *  从某一条信息开始查找之后的历史，包含这条数据  --> Event
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
- (NSArray *)queryNewerEventMessageHistoryFromCreatDate:(long long)creatDate count:(NSInteger)count uid:(NSString *)uid
{
    __block NSArray *arrayMesage;
    [DBQueue inDatabase:^(FMDatabase *db) {
        arrayMesage = [MessageTable queryNewerEventMessageHistoryWithDB:db fromCreatDate:creatDate count:count uid:uid];
    }];
    return arrayMesage;
}
/**
 *  从某一条信息开始查找之前的历史，包含这条数据  --> Event
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
- (NSArray *)queryOlderEvevtMessageHistoryFromCreatDate:(long long)creatDate count:(NSInteger)count uid:(NSString *)uid
{
    __block NSArray *arrayMesage;
    [DBQueue inDatabase:^(FMDatabase *db) {
        arrayMesage = [MessageTable queryOlderEvevtMessageHistoryWithDB:db fromCreatDate:creatDate count:count uid:uid];
    }];
    return arrayMesage;
}

/**
 *  查询此列表中,被at的数据
 *
 *  @param target 此聊天(群聊或单聊)的ID
 *  @return 查询到的数据数组
 */

- (NSArray *)queryAtMeMessageFromTarget:(NSString *)target {
    __block NSArray *arrayMessage;
    [DBQueue inDatabase:^(FMDatabase *db) {
        arrayMessage = [MessageTable queryAtMeMessageWithDB:db fromTarget:target];
    }];
    return arrayMessage;
}

/**
 *  查询此列表中,所有图片
 *
 *  @param target 此聊天(群聊或单聊)的ID
 *  @return 查询到的数据数组
 */
- (NSArray *)queryAllImageMessageFromUid:(NSString *)uid
{
    __block NSArray *arrayMesage;
    [DBQueue inDatabase:^(FMDatabase *db) {
        arrayMesage = [MessageTable queryAllImageMessageIDWithDB:db uid:uid];
    }];
    return arrayMesage;
}

/** 查询消息表里是否有某条消息的（同时匹配fromLoginName和cid）
 */
- (BOOL)queryMessageIsExsitWithBaseModel:(MessageBaseModel *)baseModel
{
    __block BOOL isExist = NO;
    [DBQueue inDatabase:^(FMDatabase *db) {
        isExist = [MessageTable queryMessageIsExistWithDB:db baseModel:baseModel];
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return isExist;
}
/**
 *  查询消息表里 的某条消息是否与同步的状态一致 (标记重点状态)
 */
- (BOOL)queryMessageIsImportantWithBaseModel:(MessageBaseModel *)baseModel
{
    __block BOOL isExist = NO;
    [DBQueue inDatabase:^(FMDatabase *db) {
        isExist = [MessageTable queryMessageIsImportantWithDB:db baseModel:baseModel];
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return isExist;
}
/**
 *  查询某个人是否是某群的群成员
 *  @param userName 群名称
 *  @param UID      此人的UID
 */
- (BOOL)queryPeopleIsGroupMembersWithGroupUserName:(NSString *)userName Show_ID:(NSString *)Show_ID
{
    __block BOOL isExist = NO;
    [DBQueue inDatabase:^(FMDatabase *db) {
        isExist = [MessageContactsTable queryPeopleIsGroupMembersWithDB:db UserName:userName Show_ID:Show_ID];
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return isExist;
    
}
/*
 * 查询某个会话中 ,缓存中的最新的消息是不是数据库中最新的
 * @param tagert 会话唯一标示符 ,会话名称
 * @param 最新消息的msgid
 *
 */
- (BOOL)queryMessageIsNewestWithTagert:(NSString *)tagert msgid:(long long)msgid
{
    __block BOOL isExist = NO;
    [DBQueue inDatabase:^(FMDatabase *db) {
        isExist = [MessageTable queryMessageIsNewestWithDB:db Tagert:tagert msgid:msgid];
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return isExist;
}
/**
 *  查询用户信息是否更改
 *
 *  @param target 用户uid
 *
 *  @return modified
 */
- (long long)queryUserProfileModified:(NSString *)target
{
    __block long long modified = -1;
    [DBQueue inDatabase:^(FMDatabase *db) {
        modified = [MessageContactsTable queryUserProfileModifiedWithDB:db uid:target];
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return modified;
}

// 查询未读消息总条数
- (NSInteger)queryAllUnreadMessageCount
{
    __block NSInteger countUnreadMessage = 0;
    [DBQueue inDatabase:^(FMDatabase *db) {
        countUnreadMessage = [MessageListTable queryAllUnreadMessageCountWithDB:db];
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return countUnreadMessage;
}

- (NSInteger)queryUnreadMessageCountWithoutUid:(NSString *)uid {
    __block NSInteger countUnreadMessage = 0;
    [DBQueue inDatabase:^(FMDatabase *db) {
        countUnreadMessage = [MessageListTable queryUnreadMessageCountWithDB:db withoutUid:uid];
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return countUnreadMessage;
}

/**
 *  查询一个联系人/群的信息
 *
 *  @param uid 联系人唯一标识符
 *
 *  @return 用户信息
 */
- (UserProfileModel *)queryContactProfileWithUid:(NSString *)uid {
    
    __block UserProfileModel *model;
    [DBQueue inDatabase:^(FMDatabase *db) {
        model = [MessageContactsTable queryUserProfileWithDB:db uid:uid];
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return model;
    
}

/**
 *  查询一个联系人的信息
 *
 *  @param nickName 联系人昵称(群聊时通过nickName获得该人的信息)
 *
 *  @return 用户信息
 */
- (UserProfileModel *)queryContactProfileWithNickName:(NSString *)nickName {
    
    __block UserProfileModel *model;
    [DBQueue inDatabase:^(FMDatabase *db) {
        model = [MessageContactsTable queryUserProfileWithDB:db nickName:nickName];
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return model;
    
}

/**
 *  查询一个联系人/群的所有未读信息
 *
 *  @param uid 联系人唯一标识符 msgId 分批查询 查询大于该msgId的消息未读的数组
 *
 *  @return 用户信息msgId数组(NSString)格式
 */
- (NSArray *)queryAllUnReadedMessageListWithUid:(NSString *)uid msgId:(long long)msgId
{
    __block NSArray *arrMsgID;
    [DBQueue inDatabase:^(FMDatabase *db) {
        arrMsgID = [MessageTable queryAllUnreadMessageIDWithDB:db uid:uid msgId:msgId];
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return arrMsgID;
}

#pragma mark - DeleteMethod
/**
 *  删除一条数据
 *
 */
- (void)deleteMessageWithModel:(MessageBaseModel *)baseModel
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        [MessageTable deleteMessageWithDB:db baseModel:baseModel];
    }];
}

// 清理表
- (void)deleteTable:(MsgTableTag)tag
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        switch (tag) {
            case table_msg:
                [MessageTable deleteMessageTableWithDB:db];
                break;
                
            case table_msgList:
                [MessageListTable deleteMessageListTableWithDB:db];
                break;
                
            case table_msgContacts:
                [MessageContactsTable deleteMessageContactTableWithDB:db];
                break;
                
            default:
                break;
        }
    }];
}

/** 清理某个聊天对象的消息记录（删除消息记录时操作，只清除消息内容，不清除消息列表的信息）
 */
- (void)deleteMessageRecordsWith:(NSString *)target
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        // 1.清理消息表
        [MessageTable deleteMessageRecordsWithDB:db uid:target];
        
        // 2.清理会话表内容（标记几个列）
        [MessageListTable deleteMessageContentWithDB:db uid:target];
    }];
}

// 清空对象所有信息
- (void)deleteMessageListWith:(NSString *)target
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        // 1.清理消息表
        [MessageTable deleteMessageRecordsWithDB:db uid:target];
        
        // 2.删除会话
        [MessageListTable deleteSessionWithDB:db uid:target];
    }];
}

- (void)deleteSessionsExcludeSession:(NSArray *)array {
    [DBQueue inDatabase:^(FMDatabase *db) {
        // 删除
        [MessageListTable deleteSessionsWithDB:db excludeSession:array];
    }];
}

#pragma mark - 好友关系 Relation
/**
 *  批量插入好友分组
 *
 *   @param array <MessageRelationGroupModel>
 */
- (void)insertRelationGroupWithArray:(NSMutableArray*)array
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        [MessageRelationGroupTable insertRelationGroups:array toDB:db];
    }];
}
/**
 * 批量插入好友信息
 *
 *  @param array <MessageRelationInfoModel>
 */
- (void)insertRelationInfoWithArray:(NSMutableArray *)array
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        [MessageRelationInfoListTable insertRelationInfoList:array toDB:db];
    }];
}
/**
 * 删除好友分组
 *
 * @param  relationGroupId 好友分组id
 */
- (void)deleteRelationGroupWithRelationGroupId:(long)relationGroupId
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        [MessageRelationGroupTable deleteRelationGroupId:relationGroupId toDB:db];
    }];
}
/**
 *  删除好友
 *
 *  @param  relationName 好友用户名
 */
- (void)deleteRelationInfoWithRelationName:(NSString *)relationName
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        [MessageRelationInfoListTable deleteRelationInfoUid:relationName toDB:db];
    }];
}
/**
 *  修改好友分组
 *
 *  @param relationGroup  MessageRelationGroupModel
 */
- (void)updateRelationGroup:(MessageRelationGroupModel *)relationGroup
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        [MessageRelationGroupTable updateRelationGroup:relationGroup toDB:db];
    }];
}
/**
 *  修改好友信息
 *
 *  @param  relationInfo 好友MessageRelationInfoModel名
 */
- (void)updateRelationInfo:(MessageRelationInfoModel *)relationInfo
{
    [DBQueue inDatabase:^(FMDatabase *db) {
        [MessageRelationInfoListTable updateRelationInfo:relationInfo toDB:db];
    }];
}
/**
 *  获取所有好友分组
 *
 *  @return  @[MessageRelationGroupModel_objs]
 */
- (NSArray *)queryRelationGroups
{
    __block NSArray *array;
    [DBQueue inDatabase:^(FMDatabase *db) {
        array = [MessageRelationGroupTable loadRelationGroupsFromDB:db];
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return array;
}

/**
 *  获取某分组下的所有好友
 *
 *  @param  relationGroupId 好友分组id
 *  @return  @[MessageRelationInfoModel_objs]
 */
- (NSArray *)queryRelationInfoWithRelationGroup:(long)relationGroupId
{
    __block NSArray *array;
    [DBQueue inDatabase:^(FMDatabase *db) {
        array = [MessageRelationInfoListTable loadRelationGroupId:relationGroupId fromDB:db];
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return array;
}

- (BOOL)queryRelationInfoWithRelationGroup:(long)relationGroupId relationName:(NSString *)relationName
{
    __block BOOL isInGroup;
    [DBQueue inDatabase:^(FMDatabase *db) {
        isInGroup = [MessageRelationInfoListTable loadRelationGroupId:relationGroupId relationName:relationName fromDB:db];
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return isInGroup;
}

- (MessageRelationInfoModel *)queryRelationInfoWithRelationName:(NSString *)relationName
{
    __block MessageRelationInfoModel *model;
    [DBQueue inDatabase:^(FMDatabase *db) {
        model = [MessageRelationInfoListTable loadRelationName:relationName fromDB:db];
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return model;
}

- (NSArray *)queryRelationInfoWithName:(NSString *)nickName remark:(NSString *)remark
{
    __block NSArray *array;
    [DBQueue inDatabase:^(FMDatabase *db) {
        array = [MessageRelationInfoListTable loadNickName:nickName remark:remark fromDB:db];
        if ([db hasOpenResultSets]) {
            [db closeOpenResultSets];
        }
    }];
    return array;
}
@end
