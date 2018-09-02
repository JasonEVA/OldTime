//
//  MessageContactsTable.h
//  launcher
//
//  Created by Andrew Shen on 15/9/24.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;
@class  UserProfileModel;

extern NSString *const kTableIMContacts;

@interface MessageContactsTable : NSObject

/**
 *  创建表
 */
+ (void)createMessageContactsTableWithDB:(FMDatabase *)db;

#pragma mark - Update

/**
 *  插入联系人
 *
 *  @param db    db
 *  @param array 联系人数组
 *
 */
+ (void)insertMessageContactsTableWithDB:(FMDatabase *)db batchData:(NSArray *)array;

#pragma mark - Query

/**
 *  查询用户信息标记
 *
 *  @param db  db
 *  @param uid 对象唯一标识符
 *
 *  @return 用户信息变更标记
 */
+ (long long)queryUserProfileModifiedWithDB:(FMDatabase *)db uid:(NSString *)uid;

/**
 *  查询一个联系人/群的信息
 *
 *  @param db  db
 *  @param uid 对象唯一标识
 *
 *  @return 联系人/群信息
 */
+ (UserProfileModel *)queryUserProfileWithDB:(FMDatabase *)db uid:(NSString *)uid;

/**
 *  查询一个联系人的信息
 *
 *  @param db  db
 *  @param nickName 对象显示的名字(昵称)
 *
 *  @return 联系人信息
 */
+ (UserProfileModel *)queryUserProfileWithDB:(FMDatabase *)db nickName:(NSString *)nickName;

#pragma mark - Delete

/**
 *  删除表
 *
 */
+ (void)deleteMessageContactTableWithDB:(FMDatabase *)db;

/**
 *  查询某个人是否是某群的群成员
 *  @param userName 群名称
 *  @param UID      此人的UID
 */
+ (BOOL)queryPeopleIsGroupMembersWithDB:(FMDatabase *)db UserName:(NSString *)userName Show_ID:(NSString *)Show_ID;


@end
