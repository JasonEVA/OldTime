//
//  MessageRelationGroupTable.m
//  MintcodeIM
//
//  Created by williamzhang on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MessageRelationGroupTable.h"
#import "MessageRelationGroupModel+SQLUtil.h"
#import <FMDB/FMDatabaseAdditions.h>
#import "MsgDefine.h"

NSString *const kTable_RelationGroup = @"table_relationGroup";

#define SQL_CREATE_RELATIONGROUP         [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (sqlId integer primary key autoincrement, relationGroupId long not null unique, relationGroupName text, createDate long long)", kTable_RelationGroup]

@implementation MessageRelationGroupTable

+ (BOOL)createTableWithDB:(FMDatabase *)db {
    BOOL success = [db executeUpdate:SQL_CREATE_RELATIONGROUP];
    [self alterMessageListTableWithDB:db];
    return success;
}

+ (void)alterMessageListTableWithDB:(FMDatabase *)db {
    if (![db columnExists:@"isDefault" inTableWithName:kTable_RelationGroup]) [db executeUpdate:@"alter TABLE table_relationGroup add isDefault INTEGER default 0"];
    if (![db columnExists:@"defaultNameFlag" inTableWithName:kTable_RelationGroup]) [db executeUpdate:@"alter TABLE table_relationGroup add defaultNameFlag INTEGER default 0"];
}

@end


@implementation MessageRelationGroupTable (Insert)

+ (void)insertRelationGroups:(NSArray<MessageRelationGroupModel *> *)relationGroups toDB:(FMDatabase *)db {
    __block BOOL isRollBack = NO;
    @try {
        [relationGroups enumerateObjectsUsingBlock:^(MessageRelationGroupModel * _Nonnull relationGroup, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@, %@, %@, %@, %@) VALUES(?,?,?,?,?)", kTable_RelationGroup,
                             relationGroup_relationGroupId,
                             relationGroup_relationGroupName,
                             relationGroup_createDate,
                             relationGroup_isDefault,
                             relationGroup_defaultNameFlag];
            BOOL result = [db executeUpdate:sql, @(relationGroup.relationGroupId), relationGroup.relationGroupName, @(relationGroup.createDate), @(relationGroup.isDefault),relationGroup_defaultNameFlag];
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

@implementation MessageRelationGroupTable (Update)

+ (BOOL)updateRelationGroup:(MessageRelationGroupModel *)relationGroup toDB:(FMDatabase *)db {
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ set %@ = ?, %@ = ?, %@ = ?", kTable_RelationGroup,
                     relationGroup_relationGroupId,
                     relationGroup_relationGroupName,
                     relationGroup_createDate];

    return [db executeUpdate:sql, @(relationGroup.relationGroupId), relationGroup.relationGroupName, @(relationGroup.createDate)];
}

@end

@implementation MessageRelationGroupTable (Delete)

+ (void)deleteRelationGroupId:(long)groupId toDB:(FMDatabase *)db {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", kTable_RelationGroup, relationGroup_relationGroupId];
    [db executeUpdate:sql, @(groupId)];
}

@end

@implementation MessageRelationGroupTable (Load)

+ (NSArray<MessageRelationGroupModel *> *)loadRelationGroupsFromDB:(FMDatabase *)db {
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", kTable_RelationGroup];
    FMResultSet *result = [db executeQuery:sql];
    while ([result next]) {
        MessageRelationGroupModel *relationGroup = [MessageRelationGroupModel sql_initWithResult:result];
        [array addObject:relationGroup];
    }
    
    return array;
}

+ (MessageRelationGroupModel *)loadDefaultGroupFromDB:(FMDatabase *)db {
    MessageRelationGroupModel *model = nil;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where %@ = 1",kTable_RelationGroup, relationGroup_isDefault];
    FMResultSet *result = [db executeQuery:sql];
    
    while ([result next]) {
        model = [MessageRelationGroupModel sql_initWithResult:result];
        return model;
    }
    
    return nil;
}

@end
