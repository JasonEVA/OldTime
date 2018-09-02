//
//  BloodPressureThriceDetectTask.m
//  HMClient
//
//  Created by lkl on 2017/5/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BloodPressureThriceDetectTask.h"
#import "BloodPressureThriceDetectModel.h"

@implementation BloodPressureThriceDetectTask

- (NSString*) postUrl
{
    //NSString* postUrl = @"http://10.0.0.172:8080/uniqueComservice2/base.do?do=httpInterface&module=userTestDataService&method=preProcessXY";
    NSString* postUrl = [ClientHelper postUserTestDataService:@"preProcessXY"];
    return postUrl;
}

@end

@implementation BloodPressureThriceDetectPeriodTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestOptionService:@"getXyTestTimes"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if (stepResult && [stepResult isKindOfClass:[NSArray class]])
    {
        NSMutableArray *reusltArray = [NSMutableArray array];
        [stepResult enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            BloodPressureThriceDetectModel *model = [BloodPressureThriceDetectModel mj_objectWithKeyValues:dic];
            [reusltArray addObject:model];
        }];
        _taskResult = reusltArray;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end


@implementation BloodPressureThriceDetectBodyStatusTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestOptionService:@"getXyBodyStatus"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if (stepResult && [stepResult isKindOfClass:[NSArray class]])
    {
        NSMutableArray *reusltArray = [NSMutableArray array];
        [stepResult enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            BloodPressureThriceDetectModel *model = [BloodPressureThriceDetectModel mj_objectWithKeyValues:dic];
            [reusltArray addObject:model];
        }];
        _taskResult = reusltArray;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end

@implementation BloodPressureThriceDetectSymptomsTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestOptionService:@"getXySymptoms"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if (stepResult && [stepResult isKindOfClass:[NSArray class]])
    {
        NSMutableArray *reusltArray = [NSMutableArray array];
        [stepResult enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            BloodPressureThriceDetectModel *model = [BloodPressureThriceDetectModel mj_objectWithKeyValues:dic];
            [reusltArray addObject:model];
        }];
        _taskResult = reusltArray;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end


