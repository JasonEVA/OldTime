//
//  HealthPlanUtil.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanUtil.h"

NSString * const kHealthPlanEditedNotificationName = @"kHealthPlanEditedNotificationName";

static HealthPlanUtil* shareUtilInstance = nil;

@interface HealthPlanUtil()
<TaskObserver>

@property (nonatomic, retain) NSDictionary* kpiListDictionary;

@end

@implementation HealthPlanUtil



+ (HealthPlanUtil*) shareInstance
{
    if (!shareUtilInstance) {
        shareUtilInstance = [[HealthPlanUtil alloc] init];
        if (!shareUtilInstance.kpiListDictionary) {
            [shareUtilInstance loadTargetWarningKpiList];
        }
    }
    return shareUtilInstance;
}

+ (void) postEditNotification
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:kHealthPlanEditedNotificationName object:nil];
}

+ (BOOL) staffHasEditPrivilege:(NSString*) status
{
    BOOL editPrivilege = NO;
    
    editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthPlanMode Status:status.integerValue OperateCode:kPrivilegeEditOperate];
    
//    NSArray* operationCodes = @[kPrivilegeEditOperate, kPrivilegeConfirmOperate];
//    
//    [operationCodes enumerateObjectsUsingBlock:^(NSString* operationCode, NSUInteger idx, BOOL * _Nonnull stop)
//     {
//         EHealthPlanOperation operation = HealthPlanOperation_None;
//         switch (idx)
//         {
//             case 0:
//                 operation = HealthPlanOperation_Commit;
//                 break;
//             case 1:
//                 operation = HealthPlanOperation_Confirm;
//                 break;
//                 
//         }
//         if (operation == HealthPlanOperation_None) {
//             return ;
//         }
//         BOOL staffPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthPlanMode Status:status.integerValue OperateCode:operationCode];
//         
//         if (staffPrivilege) {
//             *stop = YES;
//             editPrivilege = YES;
//         }
//     }];
    
    return editPrivilege;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self loadTargetWarningKpiList];
    }
    return self;
}

- (void) loadTargetWarningKpiList
{
    //GetTargetWarningKpiListTask
    [[TaskManager shareInstance] createTaskWithTaskName:@"GetTargetWarningKpiListTask" taskParam:nil TaskObserver:self];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
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
    if (taskname && [taskname isEqualToString:@"GetTargetWarningKpiListTask"])
    {
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
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
    if (taskname && [taskname isEqualToString:@"GetTargetWarningKpiListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]]) {
            _kpiListDictionary = taskResult;
        }
    }
}

- (NSArray*) targetKpiList:(NSString*) kpiCode
{
    if (!self.kpiListDictionary) {
        [self loadTargetWarningKpiList];
        return nil;
    }

    NSArray* targetKpiDictionarys = [self.kpiListDictionary valueForKey:@"target"];
    if (!targetKpiDictionarys &&
        ![targetKpiDictionarys isKindOfClass:[NSArray class]] &&
        targetKpiDictionarys.count == 0) {
        return nil;
    }
    
    __block NSMutableArray* list = nil;
    __block NSArray* kpiList = nil;
    [targetKpiDictionarys enumerateObjectsUsingBlock:^(NSDictionary* dict, NSUInteger idx, BOOL * _Nonnull stop) {
        kpiList = [dict valueForKey:kpiCode];
        if (kpiList && [kpiList isKindOfClass:[NSArray class]])
        {
//            list = kpiList;
            *stop = YES;
            return ;
        }
    }];
    
    if (kpiList && kpiList.count > 0) {
        list = [NSMutableArray array];
        [kpiList enumerateObjectsUsingBlock:^(NSDictionary* targetDict, NSUInteger idx, BOOL * _Nonnull stop) {
            HealthDetectWarningSubKpiModel* kpiModel = [HealthDetectWarningSubKpiModel mj_objectWithKeyValues:targetDict];
            HealthDetectPlanTargetModel* targetModel = [[HealthDetectPlanTargetModel alloc] init];
            targetModel.kpiName = kpiModel.subKpiName;
            targetModel.subKpiId = kpiModel.subKpiId;
            targetModel.subKpiCode = kpiModel.subKpiCode;
            
            [list addObject:targetModel];
        }];
    }
    
    return list;
}

- (NSArray*) warningKpiList:(NSString*) kpiCode
{
    if (!self.kpiListDictionary) {
        [self loadTargetWarningKpiList];
        return nil;
    }
    
    NSArray* warningKpiDictionarys = [self.kpiListDictionary valueForKey:@"warning"];
    if (!warningKpiDictionarys &&
        ![warningKpiDictionarys isKindOfClass:[NSArray class]] &&
        warningKpiDictionarys.count == 0) {
        return nil;
    }
    __block NSMutableArray* list = nil;
    __block NSArray* kpiList = nil;
    [warningKpiDictionarys enumerateObjectsUsingBlock:^(NSDictionary* dict, NSUInteger idx, BOOL * _Nonnull stop) {
        kpiList = [dict valueForKey:kpiCode];
        if (kpiList && [kpiList isKindOfClass:[NSArray class]])
        {
            *stop = YES;
            return ;
        }
    }];
    
    if (kpiList && kpiList.count > 0)
    {
        list = [NSMutableArray array];
        [kpiList enumerateObjectsUsingBlock:^(NSDictionary* warnningDict, NSUInteger idx, BOOL * _Nonnull stop) {
            HealthDetectWarningSubKpiModel* kpiModel = [HealthDetectWarningSubKpiModel mj_objectWithKeyValues:warnningDict];
            [list addObject:kpiModel];
        }];
    }
    
    return list;
}
@end
