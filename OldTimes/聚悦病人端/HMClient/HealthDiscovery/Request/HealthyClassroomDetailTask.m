//
//  HealthyClassroomDetailTask.m
//  HMClient
//
//  Created by yinquan on 17/2/9.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HealthyClassroomDetailTask.h"
#import "HealthEducationItem.h"

@implementation HealthyClassroomDetailTask


- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postMcClassServiceUrl:@"getMcClassDetail"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        HealthEducationItem* model = [HealthEducationItem mj_objectWithKeyValues:dicResp];
        _taskError = StepError_None;
        _taskResult = model;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
