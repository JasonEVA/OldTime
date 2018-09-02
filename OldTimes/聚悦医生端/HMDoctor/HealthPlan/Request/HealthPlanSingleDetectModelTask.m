//
//  HealthPlanSingleDetectModelTask.m
//  HMDoctor
//
//  Created by yinquan on 2017/9/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSingleDetectModelTask.h"

@implementation HealthPlanSingleDetectModelTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthyPlanTemplateServiceUrl:@"getSingleTestTempById"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* respDict = stepResult;
        NSArray* targetDictionarys = [respDict valueForKey:@"testTargets"];
        HealthPlanDetCriteriaModel* templateModel = [HealthPlanDetCriteriaModel mj_objectWithKeyValues:stepResult];
        [targetDictionarys enumerateObjectsUsingBlock:^(NSDictionary* targetDict, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString* targetMinValue = [targetDict valueForKey:@"targetMinValue"];
            if (targetMinValue && [targetMinValue mj_isPureInt])
            {
                HealthDetectPlanTargetModel* targetModel = templateModel.testTargets[idx];
                targetModel.targetValue = targetMinValue;
            }
            NSString* subKpiCode = [targetDict valueForKey:@"kpiCode"];
            if (subKpiCode && subKpiCode.length > 0)
            {
                HealthDetectPlanTargetModel* targetModel = templateModel.testTargets[idx];
                targetModel.subKpiCode = subKpiCode;
            }
            NSString* subKpiId = [targetDict valueForKey:@"kpiId"];
            if (subKpiId && subKpiId.length > 0)
            {
                HealthDetectPlanTargetModel* targetModel = templateModel.testTargets[idx];
                targetModel.subKpiId = subKpiId;
            }
            
        }];
        _taskResult = templateModel;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
