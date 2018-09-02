//
//  LoginAccountUtil.m
//  HMDoctor
//
//  Created by yinquan on 17/3/2.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "LoginAccountUtil.h"
#import "LoginAccountModel.h"
#import "LoginAccount.h"
#import "FMDB.h"

static NSString* kAccountTableName = @"account";
static NSString* kAccountName = @"accountname";
static NSString* kAccountPassword = @"password";
static NSString* kStaffName = @"staffName";
static NSString* kAccountPortrait = @"accountPortrait";
static NSString* kAccountLogin = @"login";

@interface LoginAccountUtil ()
{
    FMDatabase *db;
}
@end


@implementation LoginAccountUtil

- (NSString*) databasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [paths objectAtIndex:0];
    NSString* dbPath = [libPath stringByAppendingPathComponent:@"acct.db"];
    return dbPath;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSString* dbPath = [self databasePath];
        db = [FMDatabase databaseWithPath:dbPath];
        if(!db)
        {
            NSLog(@"连接数据库失败");
        }
        if (![db open]) {
            NSLog(@"open membersDB failed");
            //            return;
        }
        
        //监测数据库中我要需要的表是否已经存在
        NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'", kAccountTableName];
        FMResultSet *rs = [db executeQuery:existsSql];
        
        if ([rs next]) {
            NSInteger count = [rs intForColumn:@"countNum"];
            NSLog(@"The table count: %li", count);
            if (count == 1) {
                NSLog(@"log_keepers table is existed.");
                return self;
            }
            
            NSLog(@"log_keepers is not existed.");
            //创建表
            //[membersDB executeUpdate:@"CREATE TABLE PersonList (Name text, Age integer, Sex integer,Phone text, Address text, Photo blob)"];
            [db executeUpdate:@"CREATE TABLE account (accountname text, password text, staffName text, accountPortrait text, login int)"];
            
        }
    }
    return self;
}

- (LoginAccountModel*) currentLoginAccount
{
    if (!db)
    {
        return nil;
    }
    
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='1'", kAccountTableName, kAccountLogin];
    FMResultSet *s = [db executeQuery:sql];
    if ([s next])
    {
        NSString* accountname = [s stringForColumn:kAccountName];
        NSString* password = [s stringForColumn:kAccountPassword];
        int login = [s intForColumn:kAccountLogin];
        NSString* staffName = [s stringForColumn:kStaffName];
        NSString* userPortait = [s stringForColumn:kAccountPortrait];
        
        LoginAccountModel* model = [[LoginAccountModel alloc] init];
        
        [model setLoginAccount:accountname];
        [model setLoginPassword:password];
        [model setLogin:login];
        [model setStaffName:staffName];
        [model setUserPortrait:userPortait];
        
        return model;
    }
    return nil;
}

- (NSArray*) queryAccountList
{
    if (!db)
    {
        return nil;
    }
    
    NSMutableArray* models = [NSMutableArray array];
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@", kAccountTableName];
    FMResultSet *s = [db executeQuery:sql];
    while ([s next]) {
        //retrieve values for each record
        NSString* accountname = [s stringForColumn:kAccountName];
        NSString* password = [s stringForColumn:kAccountPassword];
        int login = [s intForColumn:kAccountLogin];
        NSString* staffName = [s stringForColumn:kStaffName];
        NSString* userPortait = [s stringForColumn:kAccountPortrait];
        
        LoginAccountModel* model = [[LoginAccountModel alloc] init];
        [model setLoginAccount:accountname];
        [model setLoginPassword:password];
        [model setLogin:login];
        [model setStaffName:staffName];
        [model setUserPortrait:userPortait];
        
        [models addObject:model];
    }
    
    return models;
}


- (void) appendAccount:(NSString*) name password:(NSString *)password staffName:(NSString*) staffName userPortrait:(NSString*) userPortrait
{
    if (!db || !name)
    {
        return;
    }
    
    if (!name || name.length == 0) {
        return;
    }
    if (!password || password.length == 0) {
        return;
    }
    if (!staffName || staffName.length == 0) {
        return;
    }
    
    NSString* updateSQL = [NSString stringWithFormat:@"UPDATE %@ SET %@='0' WHERE %@='1'", kAccountTableName, kAccountLogin, kAccountLogin];
    [db executeUpdate:updateSQL];
    
    //查找帐号是否已经在数据库中存在
    
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE accountname='%@'", kAccountTableName, name];
    FMResultSet *s = [db executeQuery:sql];
    if (![s next])
    {
        //登录帐号尚未保存
        NSLog(@"登录帐号尚未保存");
        NSString* insertsql = [NSString stringWithFormat:@"INSERT INTO %@ (accountname, password, %@, %@, login) values ('%@', '%@', '%@', '%@','1')", kAccountTableName, kStaffName, kAccountPortrait, name, password, staffName, userPortrait];
        BOOL bRet = [db executeUpdate:insertsql];
        NSLog(@"insert account %d", bRet);
    }
    else
    {
        //登录帐号已经在数据库中存在
        NSLog(@"登录帐号已经在数据库中存在");
        NSString* updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@='%@', %@='%@', %@='%@', %@='%@', %@='1' WHERE accountname='%@'", kAccountTableName, kAccountName, name, kAccountPassword, password, kStaffName, staffName, kAccountPortrait, userPortrait, kAccountLogin, name];
        BOOL bRet = [db executeUpdate:updateSql];
        NSLog(@"update account %d", bRet);
    }
}

- (void) deleteAccount:(NSString*) loginAcct
{
    if (!db || !loginAcct || loginAcct.length == 0)
    {
        return;
    }
    
    NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE accountname='%@' AND %@='0'", kAccountTableName, loginAcct, kAccountLogin];
    BOOL dbRet = [db executeUpdate:sql];
    NSLog(@"deleteAccount ret = %d", dbRet);
}

@end
