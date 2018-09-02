//
//  MessageContactsTable.m
//  launcher
//
//  Created by Andrew Shen on 15/9/24.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MessageContactsTable.h"
#import <MJExtension/MJExtension.h>
#import <FMDB/FMDataBaseAdditions.h>
#import "UserProfileModel+SQLUtil.h"
#import "IMConfigure.h"
#import "MsgDefine.h"

NSString *const kTableIMContacts = @"table_contacts";

@implementation MessageContactsTable

+ (void)createMessageContactsTableWithDB:(id)db {
     NSString *strSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (%@ INTEGER primary key autoincrement,%@ TEXT,%@ TEXT,%@ TEXT,%@ TEXT,%@ INTEGER,%@ TEXT);",
              kTableIMContacts,
              UserProfile_sqlID,
              UserProfile_userName,
              UserProfile_nickName,
              UserProfile_avatar,
              UserProfile_type,
              UserProfile_modified,
              UserProfile_memberJasonString];
    // 创建表
    if (![db executeUpdate:strSql])
    {
        NSAssert(0, @"消息联系人表创建失败");
    }
    
    [self alterTableWithDB:db];
}

+ (void)alterTableWithDB:(FMDatabase *)db {
    if (![db columnExists:@"tag" inTableWithName:kTableIMContacts])    [db executeUpdate:@"ALTER TABLE table_contacts add tag text"];
    if (![db columnExists:@"extension" inTableWithName:kTableIMContacts])    [db executeUpdate:@"ALTER TABLE table_contacts add extension text"];
}

#pragma mark - Update

/**
 *  插入联系人
 *
 *  @param db    db
 *  @param array 联系人数组
 *
 */
+ (void)insertMessageContactsTableWithDB:(FMDatabase *)db batchData:(NSArray *)array {
    UserProfileModel *model = [array firstObject];
    
    // 查看是否有此联系人
    
    // 数据库封装
    NSString *sql_tmp = [NSString stringWithFormat:@"SELECT * FROM '%@' where %@ = '%@'",
                         kTableIMContacts,
                         UserProfile_userName, model.userName];
//    PRINT_STRING(sql_tmp);
    
    // 查询数据库
    FMResultSet *result = [db executeQuery:sql_tmp];
    BOOL isExist = NO;
    // 得到未读消息条数
    //    NSString *strRealName = @"";
    while ([result next])
    {
        isExist = YES;
    }
    
    // 判断联系人中是否有此人数据，没有就插入，有就更新
    NSString *sql;
    if (isExist)
    {
        // 更新操作
        sql = [NSString stringWithFormat:
               @"UPDATE '%@' set %@ = ?,%@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? where %@ = ?",
               kTableIMContacts,
               UserProfile_nickName,
               UserProfile_avatar,
               UserProfile_modified,
               UserProfile_memberJasonString,
               UserProfile_tag,
               UserProfile_extension,
               UserProfile_userName];
        
//        PRINT_STRING(sql);
        
        // 插入数据库
        if (![db executeUpdate:sql, model.nickName, model.avatar, @(model.modified), model.memberJasonString, model.tag ,model.extension,model.userName])
        {
            NSAssert(0, @"更新联系人表失败");
        }
    }
    else
    {
        // 插入操作
        sql = [NSString stringWithFormat:@"INSERT INTO '%@' (%@,%@,%@,%@,%@,%@,%@,%@) VALUES (?,?,?,?,?,?,?,?)",
               kTableIMContacts,
               UserProfile_userName,
               UserProfile_nickName,
               UserProfile_avatar,
               UserProfile_type,
               UserProfile_modified,
               UserProfile_memberJasonString,
               UserProfile_extension,
               UserProfile_tag];
//        PRINT_STRING(sql);
        
        // 插入数据库
        if (![db executeUpdate:sql,model.userName, model.nickName, model.avatar, model.type, @(model.modified), model.memberJasonString, model.extension, model.tag])
        {
            NSAssert(0, @"插入到联系人表失败");
        }
    }

}

#pragma mark - Query

/**
 *  查询用户信息标记
 *
 *  @param db  db
 *  @param uid 对象唯一标识符
 *
 *  @return 用户信息变更标记
 */
+ (long long)queryUserProfileModifiedWithDB:(FMDatabase *)db uid:(NSString *)uid {
    long long modified = -1;
    NSString *strMessage = [NSString stringWithFormat:@"select * from '%@' where %@ = '%@'",
                            kTableIMContacts,
                            UserProfile_userName, uid];
    FMResultSet *result = [db executeQuery:strMessage];
    while ([result next])
    {
        modified = [result longLongIntForColumn:UserProfile_modified];
    }
    return modified;
}

/**
 *  查询一个联系人/群的信息
 *
 *  @param db  db
 *  @param uid 对象唯一标识
 *
 *  @return 联系人/群信息
 */
+ (UserProfileModel *)queryUserProfileWithDB:(FMDatabase *)db uid:(NSString *)uid {
    UserProfileModel *model = nil;
    
    // 查看是否有此联系人
    // 数据库封装
    NSString *selectContactProfile = [NSString stringWithFormat:@"SELECT * FROM '%@' where %@ = '%@'",
                                      kTableIMContacts,
                                      UserProfile_userName, uid];
    
    // 查询数据库
    FMResultSet *result = [db executeQuery:selectContactProfile];
    while ([result next]) {
        // 解析数据
        model = [UserProfileModel mj_objectWithKeyValues:[result resultDictionary]];
    }
    return model;
}

/**
 *  查询一个联系人的信息
 *
 *  @param db  db
 *  @param nickName 对象显示的名字(昵称)
 *
 *  @return 联系人信息
 */
+ (UserProfileModel *)queryUserProfileWithDB:(FMDatabase *)db nickName:(NSString *)nickName
{
    UserProfileModel *model;
    
    // 查看是否有此联系人
    // 数据库封装
    NSString *selectContactProfile = [NSString stringWithFormat:@"SELECT * FROM '%@' where %@ = '%@'",
                                      kTableIMContacts,
                                      UserProfile_nickName, nickName];
    
    // 查询数据库
    FMResultSet *result = [db executeQuery:selectContactProfile];
    while ([result next]) {
        // 解析数据
        model = [UserProfileModel mj_objectWithKeyValues:[result resultDictionary]];
    }
    return model;
}
/**
 *  查询某个人是否是某群的群成员
 *  @param userName 群名称
 *  @param UID      此人的UID
 */
+ (BOOL)queryPeopleIsGroupMembersWithDB:(FMDatabase *)db UserName:(NSString *)userName Show_ID:(NSString *)Show_ID
{
    BOOL isExist = NO;
    
    NSString *selectContactProfile = [NSString stringWithFormat:@"SELECT * FROM '%@' where %@ = '%@' and %@ like '%%%@%%'",
                                      kTableIMContacts,
                                      UserProfile_userName, userName,UserProfile_memberJasonString,Show_ID];
    FMResultSet *result = [db executeQuery:selectContactProfile];

    while ([result next]) {
        isExist = YES;
    }
    return isExist;
}

#pragma mark - Delete

/**
 *  删除表
 *
 */
+ (void)deleteMessageContactTableWithDB:(id)db {
    NSString *sql = [NSString stringWithFormat:@"delete from '%@'",kTableIMContacts];
    // 删除数据
    if (![db executeUpdate:sql])
    {
        NSAssert(0, @"删除会话表失败");
    }
    
}

@end
