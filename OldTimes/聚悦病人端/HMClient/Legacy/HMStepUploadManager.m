//
//  HMStepUploadManager.m
//  HMClient
//
//  Created by JasonWang on 2017/5/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMStepUploadManager.h"
#import "HealthKitManage.h"
#import <HealthKit/HealthKit.h>

@interface HMStepUploadManager ()<TaskObserver>
@property (nonatomic, copy) stepUploadBlock block;
@end

@implementation HMStepUploadManager
+ (id)shareInstance
{
    static id manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (void)JWCanUploadStepData {
    if (![[NSUserDefaults standardUserDefaults] valueForKey:[self acquireUploadKey]]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"JWCanUploadStepData" forKey:[self acquireUploadKey]];
    }
}

- (BOOL)isCanUploadData {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:[self acquireUploadKey]]) {
        return YES;
    }
    else {
        return NO;
    }
    
}
- (NSString *)acquireUploadKey {
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    return [NSString stringWithFormat:@"JWCanUploadStepData-%ld",user.userId];
}
- (void)upLoadCurrentStep:(stepUploadBlock)block {
    if (![self isCanUploadData]) {
        return;
    }
    self.block = block;
    HealthKitManage *manage = [HealthKitManage shareInstance];
    [manage authorizeHealthKit:^(BOOL success, NSError *error) {
        
        if (success) {
            NSLog(@"success");
            [manage getStepCountWithDatd:[NSDate date] completion:^(double value, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self startUploadStepRequest:value];
                    });
            }];
            
        }
        else {
            NSLog(@"fail");
        }
    }];

}

- (void)startUploadStepRequest:(NSInteger)steps {
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    [dict setObject:[[NSDate date] formattedDateWithFormat:@"yyyyMMdd"] forKey:@"exerciseDate"];
    [dict setObject:@(steps) forKey:@"stepCount"];

    [[TaskManager shareInstance] createTaskWithTaskName:@"HMAddUserExerciseRequest" taskParam:dict TaskObserver:self];
}

#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];

    if (StepError_None != taskError)
    {
        if ([taskname isEqualToString:@"HMAddUserExerciseRequest"]) {
            if (self.block) {
                self.block(NO);
            }
        }
        return;
    }
    
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"HMAddUserExerciseRequest"]) {
        if (self.block) {
            self.block(YES);
        }
    }
    
}

@end
