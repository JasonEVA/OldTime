//
//  MessageRelationInfoListTable.m
//  MintcodeIM
//
//  Created by williamzhang on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MessageRelationInfoListTable.h"
#import "MessageRelationInfoModel+SQLUtil.h"
#import <FMDB/FMDatabaseAdditions.h>
#import "MsgDefine.h"

NSString *const kTable_RelationInfo = @"table_relationInfo";


#define SQL_CREATE_RELATIONINFO [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (sqlId integer primary key autoincrement, relationGroupId long, relationName text not null unique, remark text, tag text, nickName text, relationAvatar text, relationModified long long, appName text)",kTable_RelationInfo]

@implementation MessageRelationInfoListTable

+ (BOOL)createTableWithDB:(FMDatabase *)db {
    BOOL success = [db executeUpdate:SQL_CREATE_RELATIONINFO];
    [self alterRelationListTableWithDB:db];
    return success;
}

+ (void)alterRelationListTableWithDB:(FMDatabase *)db {
    if (![db columnExists:@"imNumber" inTableWithName:kTable_RelationInfo]) {
        [db executeUpdate:@"alter TABLE table_relationInfo add imNumber text default ''"];
    }
}

@end

@implementation MessageRelationInfoListTable (Insert)

+ (void)insertRelationInfoList:(NSArray<MessageRelationInfoModel *> *)relationInfoList toDB:(FMDatabase *)db {
    __block BOOL isRollBack = NO;
    @try {
        [relationInfoList enumerateObjectsUsingBlock:^(MessageRelationInfoModel * _Nonnull relationInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES(?,?,?,?,?,?,?,?,?)", kTable_RelationInfo,
                             relationInfo_relationGroupId,
                             relationInfo_relationName,
                             relationInfo_remark,
                             relationInfo_tag,
                             relationInfo_nickName,
                             relationInfo_relationAvatar,
                             relationInfo_relationModified,
                             relationInfo_appName,
                             relationInfo_imNumber];
            BOOL result = [db executeUpdate:sql, @(relationInfo.relationGroupId), relationInfo.relationName, relationInfo.remark, relationInfo.tag, relationInfo.nickName, relationInfo.relationAvatar, @(relationInfo.relationModified), relationInfo.appName, relationInfo.imNumber];
            if (!result) {
                isRollBack = YES;
                *stop = YES;
            }
        }];
    }
    @catch (NSException *exception) {
        [db rollback];
    }
    @finally {
        if (isRollBack) {
            [db rollback];
            PRINT_STRING(@"insert to database failure content");
        }
    }
}

@end

@implementation MessageRelationInfoListTable (Update)

+ (BOOL)updateRelationInfo:(MessageRelationInfoModel *)relationInfo toDB:(FMDatabase *)db {
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ set %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?",kTable_RelationInfo,
                     relationInfo_relationGroupId,
                     relationInfo_remark,
                     relationInfo_tag,
                     relationInfo_nickName,
                     relationInfo_relationAvatar,
                     relationInfo_relationModified,
                     relationInfo_appName,
                     relationInfo_imNumber];
    return [db executeUpdate:sql, @(relationInfo.relationGroupId), relationInfo.relationName, relationInfo.remark, relationInfo.tag, relationInfo.nickName, relationInfo.relationAvatar, @(relationInfo.relationModified), relationInfo.appName, relationInfo.imNumber];
}

@end

@implementation MessageRelationInfoListTable (Delete)

+ (void)deleteRelationInfoUid:(NSString *)uid toDB:(FMDatabase *)db {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", kTable_RelationInfo, relationInfo_relationName];
    [db executeUpdate:sql, uid];
}

@end

@implementation MessageRelationInfoListTable (Load)

+ (NSArray<MessageRelationInfoModel *> *)loadRelationGroupId:(long)relationGroupId fromDB:(FMDatabase *)db {
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?", kTable_RelationInfo, relationInfo_relationGroupId];
    FMResultSet *result = [db executeQuery:sql, @(relationGroupId)];
    while ([result next]) {
        MessageRelationInfoModel *relationInfo = [MessageRelationInfoModel sql_initWithResult:result];
        [array addObject:relationInfo];
    }
    return array;
}

+ (BOOL)loadRelationGroupId:(long)relationGroupId relationName:(NSString *)relationName fromDB:(FMDatabase *)db {

    FMResultSet *result;
    if (relationGroupId != -1)
    {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? and %@ = ?", kTable_RelationInfo, relationInfo_relationGroupId,relationInfo_relationName];
        result = [db executeQuery:sql, @(relationGroupId),relationName];
    }else
    {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? ", kTable_RelationInfo,relationInfo_relationName];
        result = [db executeQuery:sql, relationName];
    }

    while ([result next]) {
        return YES;
    }
    return NO;
}

+ (MessageRelationInfoModel *)loadRelationName:(NSString *)relationName fromDB:(FMDatabase *)db {
    
    MessageRelationInfoModel *relationInfo = nil;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? ", kTable_RelationInfo,relationInfo_relationName];
        FMResultSet *result = [db executeQuery:sql, relationName];
    
    while ([result next]) {
        relationInfo = [MessageRelationInfoModel sql_initWithResult:result];
        return relationInfo;
    }
   
    return nil;
}

+ (NSArray<MessageRelationInfoModel *> *)loadNickName:(NSString *)nickName remark:(NSString *)remark fromDB:(FMDatabase *)db {
     NSMutableArray *array = [NSMutableArray array];
    
    NSString *likeNickName   = [NSString stringWithFormat:@"%%%@%%", nickName];
    NSString *likeRemarkName = [NSString stringWithFormat:@"%%%@%%", remark];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ like ? or %@ like ?",kTable_RelationInfo, relationInfo_nickName, relationInfo_remark];
    FMResultSet *result = [db executeQuery:sql, likeNickName, likeRemarkName];
    
    while ([result next]) {
    MessageRelationInfoModel *relationInfo = [MessageRelationInfoModel sql_initWithResult:result];
        [array addObject:relationInfo];
    }
    return array;
}

@end