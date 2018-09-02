//
//  MessageListTable.h
//  launcher
//
//  Created by Andrew Shen on 15/9/24.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;
@class ContactDetailModel;
@class UserProfileModel;
extern NSString *const kTableSessionList;

@interface MessageListTable : NSObject

/**
 *  创建表
 */
+ (void)createMessageListTableWithDB:(FMDatabase *)db;

#pragma mark - Update
/**
 *  更新会话列表联系人信息
 *
 *  @param userProfileModel 用户信息model
 */
+ (void)updateMessageListWithDB:(FMDatabase *)db userProfileModel:(UserProfileModel *)userProfileModel;


/**
 *  将新消息、离线消息封装成需要显示在会话列表上的样子写入到会话列表表（没有就插入，有就更新）
 *
 *  @param db                 db
 *  @param contactDetailModel 消息封装
 */
+ (void)writeToMessageListWithDB:(FMDatabase *)db data:(ContactDetailModel *)contactDetailModel;


/**
 *  将获取未读会话消息个数写入到会话列表表（没有就插入，有就更新）
 *
 *  @param db                 db
 *  @param contactDetailModel 消息封装
 */
+ (void)writeToMessageListWithDB:(FMDatabase *)db dataArray:(NSArray *)array;

/**
 *  标记会话表某个人的信息为已读
 *
 *  @param db  db
 *  @param uid 对象
 */
+ (void)updateReadedForMessageListWithDB:(FMDatabase *)db uid:(NSString *)uid;

/// 更新免打扰
+ (void)updateNotificationWithDB:(FMDatabase *)db data:(ContactDetailModel *)model;
/// 更新草稿
+ (void)updateDraftWithDB:(FMDatabase *)db target:(NSString *)target draft:(NSAttributedString *)draft;
/// 更新@信息
+ (void)updateAtMeWithDB:(FMDatabase *)db target:(NSString *)target atMe:(BOOL)atMe;
#pragma mark - Query

/**
 *  查询会话列表数据
 *  @param db  db
 *  @return 会话列表数据(model)
 */
+ (NSArray *)queryMessageListDataWithDB:(FMDatabase *)db onlyChat:(BOOL)onlyChat;

+ (NSArray *)queryGroupListWithDB:(FMDatabase *)db;

/**
 *  查询某个对象的会话
 *
 *  @param db  db
 *  @param uid 对象标识符
 */
+ (ContactDetailModel *)querySessionWithDB:(FMDatabase *)db uid:(NSString *)uid;

/**
 *  查询未读消息总数
 *
 *  @param db db
 *
 *  @return 未读消息总数
 */
+ (NSInteger)queryAllUnreadMessageCountWithDB:(FMDatabase *)db;
/**
 *  查询不包含某会话的未读消息条数
 *
 *  @param uid 不包含的uid
 *
 *  @return NSInteger
 */
+ (NSInteger)queryUnreadMessageCountWithDB:(FMDatabase *)db withoutUid:(NSString *)uid;
/**
 *  查询app消息列表数据
 *
 *  @param db  db
 *
 *  @return 会话列表数据(model)
 */
+ (NSArray *)queryAppMessageListDataWithDB:(FMDatabase *)db;

#pragma mark - Delete

/**
 *  删除某个对象会话表的信息内容（留个壳）
 *
 *  @param db  db
 *  @param uid 对象标识符
 */
+ (void)deleteMessageContentWithDB:(FMDatabase *)db uid:(NSString *)uid;

/**
 *  删除某个对象的会话
 *
 *  @param db  db
 *  @param uid 对象标识符
 */
+ (void)deleteSessionWithDB:(FMDatabase *)db uid:(NSString *)uid;

/**
 *  删除不包含数组中的数据
 *
 *  @param array contactDetailModel
 */
+ (void)deleteSessionsWithDB:(FMDatabase *)db excludeSession:(NSArray *)array;

/**
 *  删除表
 *
 */
+ (void)deleteMessageListTableWithDB:(FMDatabase *)db;

@end
