//
//  HealthPlanSummaryTask.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSummaryTask.h"

@implementation HealthPlanSummaryTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthyPlanServiceServiceUrl:@"getHealthyPlanDets"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        HealthPlanDetailModel* detailModel = [HealthPlanDetailModel mj_objectWithKeyValues:currentStep.stepResult];
        _taskResult = detailModel;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
