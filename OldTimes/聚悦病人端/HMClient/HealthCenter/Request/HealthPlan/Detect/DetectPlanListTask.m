//
//  DetectPlanListTask.m
//  HMClient
//
//  Created by lkl on 16/6/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectPlanListTask.h"
#import "SurveyPlanInfo.h"

@implementation DetectPlanListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postCommonHealthyPlanServiceUrl:@"getUserTest"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*) stepResult;
        NSMutableArray* detects = [NSMutableArray array];
        for (NSDictionary* dicGroup in lstResp)
        {
            DetectHealthPlanInfo* group = [DetectHealthPlanInfo mj_objectWithKeyValues:dicGroup];
            [detects addObject:group];
        }
        _taskResult = detects;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
