//
//  PatientInfoListDAOImpl.m
//  HMDoctor
//
//  Created by Andrew Shen on 2017/1/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "PatientInfoListDAOImpl.h"
#import "PatientInfoListSQLManager.h"


static NSString *const kPatientListUpdateDate = @"PatientListUpdateDate";

@interface PatientInfoListDAOImpl ()<TaskObserver>
@property (nonatomic, copy)  PatientListCompletionHandler  block; // <##>
@property (nonatomic, assign)  BOOL  downloading; // <##>
@property (nonatomic, copy)  PatientListFollowCompletionHandler  followCompletionBlock; // <##>
@end

@implementation PatientInfoListDAOImpl

#pragma mark - Impl

+ (void)createMessageTableWithDB:(FMDatabase *)db {
    [PatientInfoListSQLManager createMessageTableWithDB:db];
}

- (void)requestPatientList {
    if (self.downloading) {
        return;
    }
    NSLog(@"-------------->患者列表网络请求开始");
    StaffInfo *currentStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    if (!currentStaff) {
        return;
    }
    NSDictionary *dictParam = @{
                                @"staffId" : [NSString stringWithFormat:@"%ld", currentStaff.staffId]
                                };
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"GetWorkBenchPatientListTask" taskParam:dictParam TaskObserver:self];
    self.downloading = YES;
}

- (void)requestPatientListImmediately:(BOOL)immediately CompletionHandler:(PatientListCompletionHandler)completion {
    NSLog(@"-------------->开始数据库拉取");
    _block = completion;
    if (immediately) {
        // 立即刷新
        [self requestPatientList];
        return;
    }
    if (self.updated) {
        dispatch_async(self.DBActionQueue, ^{
            __weak typeof(self) weakSelf = self;
            [self.DBQueue inDatabase:^(FMDatabase *db) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                NSArray *array = [PatientInfoListSQLManager queryPatientList:db];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (strongSelf.block) {
                        NSLog(@"-------------->结束数据库拉取");
                        strongSelf.block(YES, nil, array);
                        _block = nil;
                    }
                    if ([strongSelf p_configExpired]) {
                        [strongSelf requestPatientList];
                    }
                });
            }];
        });
    }
    else {
        [self requestPatientList];
    }
}

- (void)requestPatientListImmediately:(BOOL)immediately removeDuplicateWithId:(NSString *)removeDuplicateId CompletionHandler:(PatientListCompletionHandler)completion {
    NSLog(@"-------------->开始数据库拉取");
    _block = completion;
    if (immediately) {
        // 立即刷新
        [self requestPatientList];
        return;
    }
    if (self.updated) {
        dispatch_async(self.DBActionQueue, ^{
            __weak typeof(self) weakSelf = self;
            [self.DBQueue inDatabase:^(FMDatabase *db) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                NSArray *array = [PatientInfoListSQLManager queryPatientList:db removeDuplicateWithId:removeDuplicateId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (strongSelf.block) {
                        NSLog(@"-------------->结束数据库拉取");
                        strongSelf.block(YES, nil, array);
                        _block = nil;
                    }
                    if ([strongSelf p_configExpired]) {
                        [strongSelf requestPatientList];
                    }
                });
            }];
        });
    }
    else {
        [self requestPatientList];
    }
}


- (void)updatePatientFollowStatus:(BOOL)follow patientID:(NSInteger)patientID completion:(PatientListFollowCompletionHandler)completion {
    _followCompletionBlock = completion;
    StaffInfo *currentStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    if (!currentStaff || patientID == 0) {
        return;
    }
    NSDictionary *dictParam = @{
                                @"staffId" : @(currentStaff.staffId),
                                @"userId" : @(patientID),
                                @"isAttention" : follow ? @"Y" : @"N"
                                };

    [[TaskManager shareInstance] createTaskWithTaskName:@"FollowPatientTask" taskParam:dictParam TaskObserver:self];
}

- (void)queryPatientInfoWithPatientID:(NSInteger)patientID completion:(void (^)(NewPatientListInfoModel *))completion {
    __block NewPatientListInfoModel *model;
    dispatch_async(self.DBActionQueue, ^{
        __weak typeof(self) weakSelf = self;
        [self.DBQueue inDatabase:^(FMDatabase *db) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            model = [PatientInfoListSQLManager queryPatientInfoWithPatientID:patientID DB:db];
            if (!model) {
                NSDate *updatedDate = [[NSUserDefaults standardUserDefaults] objectForKey:kPatientListUpdateDate];
                NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:updatedDate];
                // 如果没有人一分钟后才网络请求数据
                if (interval > 60) {
                    [strongSelf requestPatientList];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(model);
            });
        }];
    });
}

#pragma mark - TaskObserver
- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];

    if ([taskname isEqualToString:@"GetWorkBenchPatientListTask"])
    {
        self.downloading = NO;
        if (StepError_None != taskError) {
            self.updated = NO;
            if (self.block) {
                self.block(NO, errorMessage , @[]);
                _block = nil;
            }
            return;
        }
    }
    else if ([taskname isEqualToString:@"FollowPatientTask"]) {
        // 关注
        if (StepError_None != taskError) {
            if (self.followCompletionBlock) {
                self.followCompletionBlock(NO, errorMessage);
                _followCompletionBlock = nil;
            }
            return;
        }
    }
}

- (void)task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    if ([taskname isEqualToString:@"GetWorkBenchPatientListTask"])
    {
        NSLog(@"-------------->患者列表网络请求结束");
        self.downloading = NO;
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray<NewPatientListInfoModel *> *result = taskResult;
            self.updated = YES;
            dispatch_async(self.DBActionQueue, ^{
                __weak typeof(self) weakSelf = self;
                [self.DBQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    // 删除原数据
                    *rollback = ![PatientInfoListSQLManager deleteTableData:db];
                    // 写入数据库
                    [result enumerateObjectsUsingBlock:^(NewPatientListInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        *rollback = ![PatientInfoListSQLManager insertTableWithDB:db patients:obj];
                    }];
                    // 回调
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 更新更新时间
                        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kPatientListUpdateDate];
                        if (strongSelf.block) {
                            strongSelf.block(YES, nil , result);
                            _block = nil;
                        }
                    });
                }];

            });
        }
    }
    else if ([taskname isEqualToString:@"FollowPatientTask"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 关注
            if (self.followCompletionBlock) {
                self.followCompletionBlock(YES, nil);
                _followCompletionBlock = nil;
            }
        });
        // 更新数据库
        NSDictionary *dictParams = [TaskManager taskparamWithTaskId:taskId];
        if ([dictParams isKindOfClass:[NSDictionary class]]) {
            NSNumber *userID = dictParams[@"userId"];
            NSString *followValue = dictParams[@"isAttention"];
            if (!userID || !followValue) {
                return;
            }
            BOOL follow = NO;
            if ([followValue isEqualToString:@"Y"]) {
                follow = YES;
            }
            [self p_updatePatientStatus:follow patientID:userID.integerValue];
        }
    }
}

#pragma mark - Private Method

- (BOOL)p_configExpired {
    BOOL expired = NO;
    NSDate *updatedDate = [[NSUserDefaults standardUserDefaults] objectForKey:kPatientListUpdateDate];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:updatedDate];
    if (interval > 60 * 60) {
        expired = YES;
    }
    return expired;
}

- (void)p_updatePatientStatus:(BOOL)follow patientID:(NSInteger)userID {
    dispatch_async(self.DBActionQueue, ^{
        [self.DBQueue inDatabase:^(FMDatabase *db) {
            [PatientInfoListSQLManager updatePatientStatus:follow patientID:userID DB:db];
        }];
    });
}

@end
