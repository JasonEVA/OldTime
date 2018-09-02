//
//  MessageListTable.m
//  launcher
//
//  Created by Andrew Shen on 15/9/24.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MessageListTable.h"
#import <FMDB/FMDatabaseAdditions.h>
#import "ContactDetailModel+SQLUtil.h"
#import "ContactDetailModel+Extension.h"
#import "IMApplicationManager.h"
#import "NSString+Manager.h"
#import "UserProfileModel.h"
#import "MessageBaseModel.h"
#import "MsgUserInfoMgr.h"
#import "MsgDefine.h"

NSString *const kTableSessionList = @"table_list";

@implementation MessageListTable

+ (void)createMessageListTableWithDB:(id)db {
    NSString *strSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (%@ INTEGER primary key autoincrement,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER, %@ INTEGER, %@ INTEGER, %@ TEXT);",
                        kTableSessionList,
                        contact_sqlid,
                        contact_target,
                        contact_nickName,
                        contact_headpic,
                        contact_content,
                        contact_countUnread,
                        contact_timeStamp,
                        contact_isGroup,
                        contact_isApp,
                        contact_lastMsgId,
                        contact_info];
    // 创建表
    if (![db executeUpdate:strSql])
    {
        NSAssert(0, @"消息列表表创建失败");
    }
    
    [self alterMessageListTableWithDB:db];
}

+ (void)alterMessageListTableWithDB:(FMDatabase *)db {
    if (![db columnExists:@"_info" inTableWithName:kTableSessionList])              [db executeUpdate:@"alter TABLE table_list add _info text default ''"];
    if (![db columnExists:@"_muteNotification" inTableWithName:kTableSessionList])  [db executeUpdate:@"alter TABLE table_list add _muteNotification integer default 0"];
    if (![db columnExists:@"_draft" inTableWithName:kTableSessionList])             [db executeUpdate:@"alter TABLE table_list add _draft blob"];
    if (![db columnExists:@"_atMe" inTableWithName:kTableSessionList])              [db executeUpdate:@"alter Table table_list add _atMe integer default 0"];
    if (![db columnExists:@"_tag" inTableWithName:kTableSessionList]) [db executeUpdate:@"alter TABLE table_list add _tag text"];
    
    if (![db columnExists:@"_lastMsg" inTableWithName:kTableSessionList]) [db executeUpdate:@"alter TABLE table_list add _lastMsg text"];
}

#pragma mark - Update

/**
 *  更新会话列表联系人信息
 *
 *  @param userProfileModel 用户信息model
 */
+ (void)updateMessageListWithDB:(FMDatabase *)db userProfileModel:(UserProfileModel *)userProfileModel {
    // 更新操作
    NSString *sql = [NSString stringWithFormat:
                     @"UPDATE %@ set %@ = ?,%@ = ?, %@ = ? where %@ = ?",
                     kTableSessionList,
                     contact_headpic,
                     contact_nickName,
                     contact_tag,
                     contact_target];
    
    // 插入数据库
    if (![db executeUpdate:sql, userProfileModel.avatar, userProfileModel.nickName, userProfileModel.tag, userProfileModel.userName])
    {
        NSAssert(0, @"更新联系人信息到会话表失败");
    }

}

/**
 *  将新消息、离线消息封装成需要显示在会话列表上的样子写入到会话列表表（没有就插入，有就更新）
 *
 *  @param db                 db
 *  @param contactDetailModel 消息封装
 */
+ (void)writeToMessageListWithDB:(FMDatabase *)db data:(ContactDetailModel *)contactDetailModel {
    // 数据库封装
    NSString *sql_tmp = [NSString stringWithFormat:@"SELECT * FROM '%@' where %@ = '%@'",
                         kTableSessionList,
                         contact_target, contactDetailModel._target];
//    PRINT_STRING(sql_tmp);
    
    // 查询数据库
    FMResultSet *result = [db executeQuery:sql_tmp];
    BOOL isExist = NO;
    // 得到未读消息条数
    while ([result next])
    {
        isExist = YES;
        
        if (!contactDetailModel._getFromUnReadList)
        {
            // 获取未读会话列表的时候就以该未读为准 其他就叠加
            contactDetailModel._countUnread += [result intForColumn:contact_countUnread];
        }
        
        if (contactDetailModel._countUnread < 0)
        {
            contactDetailModel._countUnread = 0;
        }
    }
    
    // 应用就记录成1 显示是红点无数字
    if (contactDetailModel._isApp)
    {
        if (contactDetailModel._countUnread > 0)
        {
            contactDetailModel._countUnread = 1;
        }
    }
    
    // 判断联系人中是否有此人数据，没有就插入，有就更新
    NSString *sql;
    if (isExist)
    {
        // 更新操作
         sql = [NSString stringWithFormat:@"UPDATE %@ set %@ = ?,%@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? where %@ = ?",
               kTableSessionList,
               contact_content,
               contact_timeStamp,
               contact_countUnread,
               contact_nickName,
               contact_lastMsgId,
               contact_info,
               contact_lastMsg,
//               contact_tag,
               contact_target];
        
        // 插入数据库
        if (![db executeUpdate:sql, contactDetailModel._content, @(contactDetailModel._timeStamp), @(contactDetailModel._countUnread), contactDetailModel._nickName, @(contactDetailModel._lastMsgId), contactDetailModel._info, contactDetailModel._lastMsg, contactDetailModel._target])
        {
            NSAssert(0, @"更新消息数据到会话表失败");
        }
    }
    else
    {
        // 插入操作
        sql = [NSString stringWithFormat:@"INSERT INTO '%@' (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",
               kTableSessionList,
               contact_target,
               contact_nickName,
               contact_content,
               contact_headpic,
               contact_countUnread,
               contact_timeStamp,
               contact_isGroup,
               contact_isApp,
               contact_lastMsgId,
               contact_info,
               contact_tag,
               contact_lastMsg];
        
        // 插入数据库
        if (![db executeUpdate:sql,contactDetailModel._target,contactDetailModel._nickName,contactDetailModel._content,contactDetailModel._headPic, @(contactDetailModel._countUnread), @(contactDetailModel._timeStamp), @(contactDetailModel._isGroup), @(contactDetailModel._isApp), @(contactDetailModel._lastMsgId), contactDetailModel._info, contactDetailModel._tag,contactDetailModel._lastMsg])
        {
            NSAssert(0, @"插入更新消息数据到会话表失败");
        }
    }

}

/**
 *  将获取未读会话消息个数写入到会话列表表（没有就插入，有就更新）
 *
 *  @param db                 db
 *  @param contactDetailModel 消息封装
 */
+ (void)writeToMessageListWithDB:(FMDatabase *)db dataArray:(NSArray *)array
{
    for (ContactDetailModel *model in array)
    {
        [MessageListTable writeToMessageListWithDB:db data:model];
    }
}

/**
 *  标记会话表某个人的信息为已读
 *
 *  @param db  db
 *  @param uid 对象
 */
+ (void)updateReadedForMessageListWithDB:(FMDatabase *)db uid:(NSString *)uid {
    NSString *sqlMsg = [NSString stringWithFormat:@"UPDATE '%@' set '%@' = '0' where %@ = '%@'",
                        kTableSessionList,
                        contact_countUnread,
                        contact_target,uid];
    // 插入数据库
    if (![db executeUpdate:sqlMsg])
    {
        NSAssert(0, @"标记某个联系人列表消息为已读失败");
    }
}

+ (void)updateNotificationWithDB:(FMDatabase *)db data:(ContactDetailModel *)model {
    NSString *sqlMessage = [NSString stringWithFormat:@"UPDATE '%@' set '%@' = '%ld' where %@ = '%@' ",
                            kTableSessionList,
                            contact_muteNotification,model._muteNotification,
                            contact_target,model._target];
    if (![db executeUpdate:sqlMessage]) {
        NSAssert(0, @"更新免打扰失败");
    }
}


+ (void)updateDraftWithDB:(FMDatabase *)db target:(NSString *)target draft:(NSAttributedString *)draft {
    
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:draft forKey:contact_draft];
    [archiver finishEncoding];
    
    NSString *sql = [NSString stringWithFormat:@"update '%@' set %@ = ? where %@ = '%@'",
                     kTableSessionList,
                     contact_draft,
                     contact_target,target];

    [db executeUpdate:sql,data];
}

+ (void)updateAtMeWithDB:(FMDatabase *)db target:(NSString *)target atMe:(BOOL)atMe {
    NSString *sql = [NSString stringWithFormat:@"update '%@' set %@ = ? where %@ = ?",
                            kTableSessionList,
                            contact_atMe,contact_target];
    [db executeUpdate:sql, @(atMe), target];
}

#pragma mark - Query

/**
 *  查询会话列表数据
 *
 *  @return 会话列表数据(model)
 */
+ (NSArray *)queryMessageListDataWithDB:(FMDatabase *)db onlyChat:(BOOL)onlyChat {
    // 1.遍历ContactAll联系人总表去取出有
    
    NSMutableArray *arrMsgList = [NSMutableArray array];
    
    NSString *addtional = @"";
    if (onlyChat) {
        addtional = [NSString stringWithFormat:@"where %@ != 1 and %@ != '%@'", contact_isApp, contact_target, MTRelationTarget];
    }
    
    // 有SHOW_IN_LIST的标记才显示，同时去除自身的幽灵消息 (去除应用消息)
    NSString *strPickMessge = [NSString stringWithFormat:@"select * from '%@' %@ order by %@ desc",
                               kTableSessionList,
                               addtional,
                               contact_timeStamp];
    
    FMResultSet *result = [db executeQuery:strPickMessge];
    while ([result next])
    {
        // 1.得到消息对象
        ContactDetailModel *model = [ContactDetailModel sql_initWithResult:result];

        if (![model._nickName length] && !model._isApp && ![model isRelationSystem]) {
            continue;
        }
        
        [arrMsgList addObject:model];
    }
    
    return arrMsgList;
}

+ (NSArray *)queryGroupListWithDB:(FMDatabase *)db {
    NSArray *allMsgList = [self queryMessageListDataWithDB:db onlyChat:YES];
    
    NSMutableArray *groupList = [NSMutableArray array];
    
    for (ContactDetailModel *detail in allMsgList) {
        if ([ContactDetailModel isGroupWithTarget:detail._target]) {
            [groupList addObject:detail];
        }
    }
    
    return groupList;
}

/**
 *  查询某个对象的会话
 *
 *  @param db  db
 *  @param uid 对象标识符
 */
+ (ContactDetailModel *)querySessionWithDB:(FMDatabase *)db uid:(NSString *)uid {
    ContactDetailModel *model;
    NSString *strPickMessge = [NSString stringWithFormat:@"select * from '%@' where %@ = '%@'",
                               kTableSessionList,
                               contact_target, uid
                               ];
    FMResultSet *result = [db executeQuery:strPickMessge];
    while ([result next])
    {
        model = [ContactDetailModel sql_initWithResult:result];
    }
    return model;
}

/**
 *  查询app消息列表数据
 *
 *  @param db  db
 *
 *  @return 会话列表数据(model)
 */
+ (NSArray *)queryAppMessageListDataWithDB:(FMDatabase *)db {
    // 1.遍历ContactAll联系人总表去取出有
    
    NSMutableArray *arrMsgList = [NSMutableArray array];
    
    // 有SHOW_IN_LIST的标记才显示，同时去除自身的幽灵消息
    NSString *strPickMessge = [NSString stringWithFormat:@"select * from '%@' where %@ = '1' order by %@ asc",
                               kTableSessionList,
                               contact_isApp,
                               contact_sqlid];
    FMResultSet *result = [db executeQuery:strPickMessge];
    while ([result next])
    {
        // 1.得到消息对象
        ContactDetailModel *model = [ContactDetailModel sql_initWithResult:result];
        
        [arrMsgList addObject:model];
    }
    
    return arrMsgList;
}

/**
 *  查询未读消息总数
 *
 *  @param db db
 *
 *  @return 未读消息总数
 */
+ (NSInteger)queryAllUnreadMessageCountWithDB:(FMDatabase *)db {
    
    // 有SHOW_IN_LIST的标记才显示，同时去除自身的幽灵消息
    NSString *strPickMessge = [NSString stringWithFormat:@"select SUM(%@) from '%@' WHERE %@ != '%@' and %@ > 0 and %@ != '' and %@ = 0 and %@ != '1'",
                               contact_countUnread,
                               kTableSessionList,
                               contact_target, [[MsgUserInfoMgr share] getUid],
                               contact_countUnread,
                               contact_nickName,
                               contact_muteNotification,
                               contact_isApp];
    FMResultSet *result = [db executeQuery:strPickMessge];
    while ([result next])
    {
       return [result intForColumnIndex:0];
    }

    return 0;
}

+ (NSInteger)queryUnreadMessageCountWithDB:(FMDatabase *)db withoutUid:(NSString *)uid {

    // 有SHOW_IN_LIST的标记才显示，同时去除自身的幽灵消息
    NSString *strPickMessge = [NSString stringWithFormat:@"select SUM(%@) from '%@' WHERE %@ != '%@' and %@ > 0 and %@ != '' and %@ != '%@' and %@ = 0 and %@ != 1",
                               contact_countUnread,
                               kTableSessionList,
                               contact_target, [[MsgUserInfoMgr share] getUid],
                               contact_countUnread,
                               contact_nickName,
                               contact_target, uid,
                               contact_muteNotification,
                               contact_isApp];
    FMResultSet *result = [db executeQuery:strPickMessge];
    while ([result next]) {
        return [result intForColumnIndex:0];
    }
    
    return 0;
}

#pragma mark - Delete

/**
 *  删除某个对象会话表的信息内容（留个壳）
 *
 *  @param db  db
 *  @param uid 对象标识符
 */
+ (void)deleteMessageContentWithDB:(FMDatabase *)db uid:(NSString *)uid {
    NSString *sql = [NSString stringWithFormat:@"update '%@' set '%@' = '%@' where %@ = '%@'",
                     kTableSessionList,
                     contact_content,@"",
                     contact_target,uid];
    // 更新数据
    if (![db executeUpdate:sql])
    {
        NSAssert(0, @"清空对象会话表内容失败");
    }
}

/**
 *  删除某个对象的会话
 *
 *  @param db  db
 *  @param uid 对象标识符
 */
+ (void)deleteSessionWithDB:(FMDatabase *)db uid:(NSString *)uid {
    NSString *sql = [NSString stringWithFormat:@"delete from '%@' where %@ = '%@'",
                     kTableSessionList,
                     contact_target,uid];
    // 更新数据
    if (![db executeUpdate:sql])
    {
        NSAssert(0, @"删除对象的会话失败");
    }
}

+ (void)deleteSessionsWithDB:(FMDatabase *)db excludeSession:(NSArray *)array {
    NSArray *appUids = [IMApplicationManager applicaitonUids];
    NSMutableArray *targets = [NSMutableArray array];
    for (NSString *appUid in appUids) {
        [targets addObject:[NSString stringWithFormat:@"'%@'", appUid]];
    }
    NSString *excludeTarget = [targets componentsJoinedByString:@","];

    for (ContactDetailModel *model in array) {
        excludeTarget = [excludeTarget stringByAppendingFormat:@", '%@'",model._target];
    }
    
    NSString *sql = [NSString stringWithFormat:@"delete from '%@' where %@ not in (%@)",
                     kTableSessionList,
                     contact_target,excludeTarget];

    if (![db executeUpdate:sql]) {
        NSAssert(0, @"删除多余会话失败");
    }
}

/**
 *  删除表
 *
 */
+ (void)deleteMessageListTableWithDB:(FMDatabase *)db {
    NSString *sql = [NSString stringWithFormat:@"delete from '%@'",kTableSessionList];
    // 删除数据
    if (![db executeUpdate:sql])
    {
        NSAssert(0, @"删除消息表表数据失败");
    }
}

@end
