//
//  HealthPlanCheckServiceTask.m
//  HMDoctor
//
//  Created by yinquan on 2017/9/14.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanCheckServiceTask.h"

@implementation HealthPlanCheckServiceTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthyPlanServiceServiceUrl:@"checkUserHealthyPlan"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        _taskResult = stepResult;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
