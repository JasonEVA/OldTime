//
//  HMCheckPatientServiceManager.m
//  HMDoctor
//
//  Created by jasonwang on 2017/2/22.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMCheckPatientServiceManager.h"
#import "JsonHttpClient.h"
#import "ClientHelper.h"

@interface HMCheckPatientServiceManager ()<TaskObserver>
@property (nonatomic, copy) managerCompletion completionBlock;
@end

@implementation HMCheckPatientServiceManager

+ (HMCheckPatientServiceManager *)shareManager{
    static HMCheckPatientServiceManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HMCheckPatientServiceManager alloc] init];
    });
    return manager;
}

- (void)checkPatientServiceWithUserId:(NSString *)userId completion:(managerCompletion)completion {
    [self requestWithUserId:userId];
    self.completionBlock = completion;
}

- (void)requestWithUserId:(NSString *)userId{

//    NSMutableDictionary *params = [ClientHelper buildCommonHttpParam];
//    params[@"userId"] = userId;
//    NSString *url = [ClientHelper postUserServicePoServiceUrl:@"checkUserIsOrderService"];
//    JsonHttpClient *httpClient = [[JsonHttpClient alloc]init];
//    [httpClient startJsonPost:url Param:params];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"userId"] = userId;
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMCheckPatientServiceRequest" taskParam:dict TaskObserver:self];

}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (errorMessage.length && StepError_None != taskError)
    {
        if (self.completionBlock) {
            self.completionBlock(0,@[],NO);
            _completionBlock = nil;
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
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    NSDictionary* dicResp = (NSDictionary*)taskResult;
    NSString* hasService = [dicResp valueForKey:@"hasService"];
    PatientServiceStatus serviceStatus;
    if (hasService.length && [hasService isEqualToString:@"Y"]) {
        serviceStatus = PatientServiceStatus_YES;
    }
    else {
        serviceStatus = PatientServiceStatus_NO;
    }

    NSDictionary *privilege = [dicResp valueForKey:@"privilege"];
    NSMutableArray *privilegeArr = [NSMutableArray arrayWithArray:@[]];
    if (privilege) {
        [privilege enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:@"YZ"]) {
                [privilegeArr addObject:@(PatientPrivilege_YZ)];
            }
            if ([key isEqualToString:@"JKJH"]) {
                [privilegeArr addObject:@(PatientPrivilege_JKJH)];
            }
            if ([key isEqualToString:@"JKBG"]) {
                [privilegeArr addObject:@(PatientPrivilege_JKBG)];
            }
            if ([key isEqualToString:@"JKDA"]) {
                [privilegeArr addObject:@(PatientPrivilege_JKDA)];
            }
            if ([key isEqualToString:@"TWZX"]) {
                [privilegeArr addObject:@(PatientPrivilege_TWZX)];
            }
        }];
    }
    
    if (self.completionBlock) {
        self.completionBlock(serviceStatus,privilegeArr,YES);
        _completionBlock = nil;
    }
    
    
    
}
@end
