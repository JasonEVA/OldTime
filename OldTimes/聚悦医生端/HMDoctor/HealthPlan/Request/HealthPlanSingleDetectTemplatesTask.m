//
//  HealthPlanSingleDetectTemplatesTask.m
//  HMDoctor
//
//  Created by yinquan on 2017/9/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSingleDetectTemplatesTask.h"

@implementation HealthPlanSingleDetectTemplatesTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthyPlanTemplateServiceUrl:@"getSingleTestTemp"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        HealthPlanSingleDetectSectionModel* templateModel = [HealthPlanSingleDetectSectionModel mj_objectWithKeyValues:stepResult];
        NSMutableArray* templates = [NSMutableArray array];
        [templates addObject:templateModel];
        _taskResult = templates;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
