//
//  SurveyPlanListTask.m
//  HMClient
//
//  Created by lkl on 16/6/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SurveyPlanListTask.h"
#import "SurveyPlanInfo.h"

@implementation SurveyPlanListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postCommonHealthyPlanServiceUrl:@"getSurveyPlan"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*) stepResult;
        NSMutableArray* surveys = [NSMutableArray array];
        for (NSDictionary* dicGroup in lstResp)
        {
            SurveyPlanInfo* group = [SurveyPlanInfo mj_objectWithKeyValues:dicGroup];
            [surveys addObject:group];
        }
        _taskResult = surveys;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
