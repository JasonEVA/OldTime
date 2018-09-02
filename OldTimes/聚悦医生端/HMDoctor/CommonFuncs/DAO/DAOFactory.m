//
//  DAOFactory.m
//  HMDoctor
//
//  Created by Andrew Shen on 2017/1/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "DAOFactory.h"
#import <FMDB/FMDatabase.h>
#import <FMDB/FMDatabaseQueue.h>
#import "PatientInfoListDAOImpl.h"

static NSString *const kDBModule = @"DBHMDoctor";
#define kDBQueueSpecific "com.juyuejk.doctorDBQueue"

@interface DAOFactory ()
@property (nonatomic, assign)  BOOL  createDBSuccess; // <##>
@property (nonatomic, strong)  FMDatabaseQueue  *DBQueue; // 数据库管理
@property (nonatomic, copy)  NSString  *uid; // <##>
@property (nonatomic, readwrite)  dispatch_queue_t  DBActionQueue; // <##>
@property (nonatomic, strong, readwrite)  id<PatientInfoListDAOProtocol>  patientInfoListDAO; // 患者列表

@end

@implementation DAOFactory

#pragma mark - Interface Method

+ (instancetype)sharedInstance {
    static DAOFactory *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DAOFactory alloc] init];
    });
    instance.createDBSuccess = [instance createDB];
    return instance;
}

- (BOOL)createDB {
    UserInfo *user = [[UserInfoHelper defaultHelper] currentUserInfo];
    NSString *uid = [NSString stringWithFormat:@"%ld",user.userId];
    if (!uid || uid.length == 0 || [self.uid isEqualToString:uid]) {
        return NO;
    }
    if (self.DBQueue) {
        [self closeDB];
    }
    NSString *dbName = [NSString stringWithFormat:@"%@.%@", kDBModule, @"db"];
    NSString *realDBPath = [self p_getDocumentsPathWithDirName:uid];
    realDBPath = [realDBPath stringByAppendingPathComponent:dbName];
    self.DBQueue = [FMDatabaseQueue databaseQueueWithPath:realDBPath];
    self.uid = uid;
    [self p_createTables];
    return YES;
}

- (void)closeDB {
    if (self.DBQueue) {
        [self.DBQueue close];
        self.uid = nil;
        self.patientInfoListDAO = nil;
    }
}

- (void)p_createTables {
    [self.DBQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [PatientInfoListDAOImpl createMessageTableWithDB:db];
    }];
}

#pragma mark - Private Method

// 返回包含到文件夹的全路径，如果没有则创建一个
- (NSString *)p_getDocumentsPathWithDirName:(NSString *)dirName
{
    NSFileManager *fm = [NSFileManager defaultManager];
    // 文件夹不存在则创建
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 当前登录用户名为总文件夹，确保切换登录账号不会造成数据错误
    NSString * documentsdir = [[paths objectAtIndex:0] stringByAppendingPathComponent:dirName];
    BOOL isDir;
    BOOL isExist = [fm fileExistsAtPath:documentsdir isDirectory:&isDir];
    // 文件夹不存在
    if (!(isExist && isDir))
    {
        // 创建一个
        [fm createDirectoryAtPath:documentsdir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return documentsdir;
}

#pragma mark - Init
- (dispatch_queue_t)DBActionQueue {
    if (!_DBActionQueue) {
        _DBActionQueue = dispatch_queue_create(kDBQueueSpecific, NULL);
    }
    return _DBActionQueue;
}

- (id<PatientInfoListDAOProtocol>)patientInfoListDAO {
    if (!_patientInfoListDAO) {
        self.patientInfoListDAO = [[PatientInfoListDAOImpl alloc] initWithDBQueue:self.DBQueue DBActionQueue:self.DBActionQueue];;
    }
    return _patientInfoListDAO;
}

@end
