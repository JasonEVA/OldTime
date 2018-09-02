////
////  UnifiedSqlManager.m
////  Titans
////
////  Created by Andrew Shen on 14-8-30.
////  Copyright (c) 2014年 Remon Lv. All rights reserved.
////

#import "UnifiedSqlManager.h"
#import "ContactPersonDetailInformationModel.h"
#import "UnifiedFilePathManager.h"
#import "UnifiedUserInfoManager.h"
#import "FMDatabase.h"

@interface UnifiedSqlManager ()

@property (nonatomic, strong) FMDatabase *fmdb;
@property (nonatomic, strong) NSMutableDictionary *dictTables;

@property (nonatomic, strong) dispatch_queue_t contactQueue;

/** 目前正在使用数据库的用户名 */
@property (nonatomic, copy) NSString *userUid;

@end

@implementation UnifiedSqlManager

// 单例
+ (UnifiedSqlManager *)share
{
    static UnifiedSqlManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    
    [shareInstance dbOpenNewPathIfNeed];
    return shareInstance;
}

- (void)dbOpenNewPathIfNeed {
    NSString *newUid = [[UnifiedUserInfoManager share] userShowID];
    if ([newUid isEqualToString:self.userUid]) {
        // 已经创建过数据库
        return;
    }
    
    if (![newUid length]) {
        return;
    }
    
    // 有需求，创建数据库
    NSString *sqlPath = [NSString stringWithFormat:@"%@/%@.sqlite",[[UnifiedFilePathManager share] getClassPathWithTag:class_tag_sql],newUid];
    _fmdb = [FMDatabase databaseWithPath:sqlPath];
    if (![_fmdb open]) {
        NSAssert(0, @"数据库打开失败");
        return;
    }
    
    self.userUid = newUid;
    // 初始化dict
    _dictTables = [NSMutableDictionary dictionary];
    // 批量创建表，并存入dict中
    for (UnifiedClassManagerTag tag = (class_tag_min + 1); tag < class_tag_max; tag ++)
    {
        NSString *strTableName = [[UnifiedFilePathManager share] getClassNameWithTag:tag];
        if (strTableName != nil)
        {
            [_dictTables setObject:strTableName forKey:[NSNumber numberWithInteger:tag]];
        }
    }
    
    // 批量创建数据库和表（自动判断是否存在）
    [self createTables];
}

#pragma mark - Private Method
// 创建表
- (void)createTables
{
    // 打开数据库
    [_fmdb open];
    
    // 事务
    [_fmdb beginTransaction];
    BOOL isRollBack = NO;
    @try
    {
        // 遍历表名dict
        NSArray *arrTableName = [_dictTables allKeys];
        NSString *strSql = @"";
        NSString *strTableName = @"";
        for (NSNumber *tableKey in arrTableName)
        {
            // 取出表名
            strTableName = [_dictTables objectForKey:tableKey];
            
            // 生成建表语句
            UnifiedClassManagerTag tag = (UnifiedClassManagerTag)[tableKey integerValue];
            switch (tag) {
                case class_tag_allContacts:
                    strSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'   \
                              (%@ INTEGER primary key autoincrement,                        \
                              %@ TEXT, %@ TEXT, %@ TEXT,%@ TEXT, %@ TEXT, %@ BOOLEAN, %@ BOOLEAN, %@ BOOLEAN, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ long long);",
                              strTableName,
                              personDetail_sqlid,
                              personDetail_show_id,
                              personDetail_headPic,
                              personDetail_u_name,
                              personDetail_u_true_name,
                              personDetail_u_true_name_c,
                              personDetail_u_status,
                              personDetail_u_sort,
                              personDetail_is_admin,
                              personDetail_c_show_id,
                              personDetail_create_user,
                              personDetail_create_time,
                              personDetail_create_user_name,
                              personDetail_d_name,
                              personDetail_u_dept_id,
                              personDetail_d_parentid_show_id,
                              personDetail_d_path_name,
                              personDetail_u_mobile,
                              personDetail_u_mail,
                              personDetail_u_job,
                              personDetail_u_telephone,
                              personDetail_u_hira,
                              personDetail_extension,
                              personDetail_modified];
                    break;
                default:
                    break;
            }
            
            // 创建表
            if (![_fmdb executeUpdate:strSql])
            {
                NSAssert(0, @"表创建失败");
                isRollBack = YES;
            }
        }
    }
    @catch (NSException *exception)
    {
        isRollBack = YES;
    }
    @finally
    {
        if (!isRollBack)
        {
            [_fmdb commit];
        }
        else
        {
            [_fmdb rollback];
        }
    }
    // 关闭数据库
    [_fmdb close];
}

- (NSArray *)findAllContactPeople {
    NSMutableArray *arrayPeople = [NSMutableArray array];
    
    [_fmdb open];
    
    NSString *sql_tmp = [NSString stringWithFormat:@"SELECT * FROM '%@'",[_dictTables objectForKey:@(class_tag_allContacts)]];
    
    FMResultSet *result = [_fmdb executeQuery:sql_tmp];
    while ([result next])
    {
        ContactPersonDetailInformationModel *model = [[ContactPersonDetailInformationModel alloc] initWithFMResult:result];
        //  将model加入数组
        [arrayPeople addObject:model];
    }

    [_fmdb close];
    
    return arrayPeople;
}

- (ContactPersonDetailInformationModel *)findPersonWithUserName:(NSString *)userName {
    [_fmdb open];
    
    NSString *strTableName = [_dictTables objectForKey:@(class_tag_allContacts)];
    
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM '%@' where %@ = '%@'", strTableName, personDetail_u_name, userName];

    FMResultSet *result = [_fmdb executeQuery:selectSql];
    while (![result next]) {
        return nil;
    }
    
    ContactPersonDetailInformationModel *model = [[ContactPersonDetailInformationModel alloc] initWithFMResult:result];
    
    [_fmdb close];
    return model;
}

- (ContactPersonDetailInformationModel *)findPersonWithShowId:(NSString *)showId {
    [_fmdb open];
    
    // 联系人总表表名
    NSString *strTableName = [_dictTables objectForKey:@(class_tag_allContacts)];
    
    // 数据库封装
    NSString *sql_tmp = [NSString stringWithFormat:@"SELECT * FROM '%@' where %@ = '%@'",strTableName, personDetail_show_id, showId];
    
    // 查询数据库
    FMResultSet *result = [_fmdb executeQuery:sql_tmp];
    while (![result next]) {
        return nil;
    }
    
    ContactPersonDetailInformationModel *model = [[ContactPersonDetailInformationModel alloc] initWithFMResult:result];
    
    [_fmdb close];
    return model;
}

- (BOOL)insertContactDetail:(NSArray *)array {
    dispatch_async(self.contactQueue, ^{
        [_fmdb open];
        
        [_fmdb beginTransaction];
        BOOL isRollBack = NO;
        @try {
            NSString *allContactTableName = [_dictTables objectForKey:@(class_tag_allContacts)];
            
            for (ContactPersonDetailInformationModel *model in array) {
                // 插入到联系人总表
                NSString *sql = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE %@ = '%@'",allContactTableName, personDetail_show_id, model.show_id];
                //            PRINT_STRING(sql);
                
                BOOL isExist = NO;
                FMResultSet *resultSet = [_fmdb executeQuery:sql];
                while ([resultSet next]) {
                    isExist = YES;
                }
                
                if (!isExist) {
                    // 不存在
                    NSString *commonUser = [NSString stringWithFormat:@"INSERT INTO '%@' (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) VALUES ('%@','%@','%@','%@','%@','%d','%d','%d','%@','%@','%lld','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%lld')",
                                            allContactTableName,
                                            personDetail_headPic,
                                            personDetail_show_id,
                                            personDetail_u_name,
                                            personDetail_u_true_name,
                                            personDetail_u_true_name_c,
                                            personDetail_u_status,
                                            personDetail_u_sort,
                                            personDetail_is_admin,
                                            personDetail_c_show_id,
                                            personDetail_create_user,
                                            personDetail_create_time,
                                            personDetail_create_user_name,
                                            personDetail_d_name,
                                            personDetail_u_dept_id,
                                            personDetail_d_parentid_show_id,
                                            personDetail_d_path_name,
                                            personDetail_u_mobile,
                                            personDetail_u_mail,
                                            personDetail_u_hira,
                                            personDetail_u_job,
                                            personDetail_u_telephone,
                                            personDetail_extension,
                                            personDetail_modified,
                                            model.sqlheadPic,
                                            model.sqlshow_id,
                                            model.sqlu_name,
                                            model.sqlu_true_name,
                                            model.sqlu_true_name_c,
                                            model.sqlu_status,
                                            model.sqlu_sort,
                                            model.sqlis_admin,
                                            model.sqlc_show_id,
                                            model.sqlcreate_user,
                                            model.sqlcreate_time,
                                            model.sqlcreate_user_name,
                                            model.sqld_name,
                                            model.sqlu_dept_id,
                                            model.sqld_parentid_show_id,
                                            model.sqld_path_name,
                                            model.sqlu_mobile,
                                            model.sqlu_mail,
                                            model.sqlu_hira,
                                            model.sqlu_job,
                                            model.sqlu_telephone,
                                            model.sqlextension,
                                            model.sql_modified];
                    //                PRINT_STRING(commonUser);
                    // 插入数据库
                    if (![_fmdb executeUpdate:commonUser])
                    {
                        NSAssert(0, @"插入联系人失败");
                        isRollBack = YES;
                    }
                } else {
                    // 存在，更新信息
                    NSString *strUpdate = [NSString stringWithFormat:@"update '%@' set %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%d', %@ = '%d', %@ = '%d', %@ = '%@', %@ = '%@', %@ = '%lld',%@ = '%@',%@ = '%@',%@ = '%@',%@ = '%@',%@ = '%@',%@ = '%@',%@ = '%@',%@ = '%@',%@ = '%@',%@ = '%@',%@ = '%@',%@ = '%lld' where %@ ='%@'",
                                           allContactTableName,
                                           personDetail_headPic,            model.sqlheadPic,
                                           personDetail_u_name,             model.sqlu_name,
                                           personDetail_u_true_name,        model.sqlu_true_name,
                                           personDetail_u_true_name_c,      model.sqlu_true_name_c,
                                           personDetail_u_status,           model.sqlu_status,
                                           personDetail_u_sort,             model.sqlu_sort,
                                           personDetail_is_admin,           model.sqlis_admin,
                                           personDetail_c_show_id,          model.sqlc_show_id,
                                           personDetail_create_user,        model.sqlcreate_user,
                                           personDetail_create_time,        model.sqlcreate_time,
                                           personDetail_create_user_name,   model.sqlcreate_user_name,
                                           personDetail_u_dept_id,          model.sqlu_dept_id,
                                           personDetail_d_parentid_show_id, model.sqld_parentid_show_id,
                                           personDetail_d_path_name,        model.sqld_path_name,
                                           personDetail_u_mail,             model.sqlu_mail,
                                           personDetail_u_mobile,           model.sqlu_mobile,
                                           personDetail_d_name,             model.sqld_name,
                                           personDetail_u_hira,             model.sqlu_hira,
                                           personDetail_u_job,              model.sqlu_job,
                                           personDetail_u_telephone,        model.sqlu_telephone,
                                           personDetail_extension,          model.sqlextension,
                                           personDetail_modified,           model.sql_modified,
                                           personDetail_show_id,            model.sqlshow_id];
                    //                PRINT_STRING(strUpdate);
                    // 插入数据库
                    if (![_fmdb executeUpdate:strUpdate])
                    {
                        NSAssert(0, @"更新联系人失败");
                        isRollBack = YES;
                    }
                    
                }
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
        }
        @finally {
            if (!isRollBack) {
                [_fmdb commit];
            }else {
                [_fmdb rollback];
            }
        }
        
        [_fmdb close];
    });
    
    return YES;
}

- (void)deleteAllContact {
    [self deleteAllContactCompletion:nil];
}

- (void)deleteAllContactCompletion:(void (^)())completion {
    dispatch_async(self.contactQueue, ^{
        [_fmdb open];
        
        NSString *allContactTableName = [_dictTables objectForKey:@(class_tag_allContacts)];
        
        NSString *sqlTmp = [NSString stringWithFormat:@"DELETE FROM '%@'",allContactTableName];
        [_fmdb executeUpdate:sqlTmp];
        
        [_fmdb close];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion();
        });
    });
}

#pragma mark - 
#pragma mark - Initializer
- (dispatch_queue_t)contactQueue {
    if (!_contactQueue) {
        _contactQueue = dispatch_queue_create("Launchr.Contact.Queue", NULL);
    }
    return _contactQueue;
}

@end
