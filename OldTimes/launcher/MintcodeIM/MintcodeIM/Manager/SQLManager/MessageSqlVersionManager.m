//
//  MessageSqlVersionManager.m
//  launcher
//
//  Created by williamzhang on 16/3/4.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MessageSqlVersionManager.h"
#import <FMDB/FMDatabaseAdditions.h>
#import "MessageRecallTable.h"
#import "MessageTable.h"

uint32_t const IM_SQL_VERSION = 1;

@implementation MessageSqlVersionManager

+ (void)versionUpdateIfNeedInDatabase:(FMDatabase *)database {
    uint32_t currentVersion = [database userVersion];
    if (currentVersion == IM_SQL_VERSION) {
        return;
    }
    
    [self database:database updatedVersion:1 updateIfNeedCompletion:^{
        [self versionOneUpdate:database];
    }];
}

/**
 *  第一个版本,将messageTable的type值Int改为String
 *  该版本会将之前的messageTable删除，然后重新生成
 *  所以更新版本后之前数据会丢失，需要重新获取历史
 */

+ (BOOL)versionOneUpdate:(FMDatabase *)database {
    BOOL dropMessageTable = NO;
    if (![database tableExists:kTableMessage]) {
        dropMessageTable = YES;
    }

    NSString *sql;
    if (!dropMessageTable) {
        sql = [NSString stringWithFormat:@"drop table %@",kTableMessage];
        dropMessageTable = [database executeUpdate:sql];
    }
    
    BOOL dropRecallTable = NO;
    if (![database tableExists:kRecallTable]) {
        dropRecallTable = YES;
        return dropRecallTable && dropMessageTable;
    }
    
    sql = [NSString stringWithFormat:@"drop table %@", kRecallTable];
    dropRecallTable = [database executeUpdate:sql];
    return dropRecallTable && dropMessageTable;
}

/**
 *  更新数据库
 *
 *  @param database   待更新数据库
 *  @param version    待更新到的版本
 *  @param completion 待更新的内容回调
 */
+ (void)database:(FMDatabase *)database updatedVersion:(uint32_t)version updateIfNeedCompletion:(void (^)())completion {
    
    NSParameterAssert(completion);
    
    uint32_t currentVersion = [database userVersion];
    if (currentVersion < version) {
        completion();
        [database setUserVersion:version];
    }
}

@end
