//
//  PsychologyDetailTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PsychologyDetailTask.h"
#import "UserPsychologyDetail.h"

@implementation PsychologyDetailTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postCommonHealthyPlanServiceUrl:@"getUserMentality"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        UserPsychologyDetail* detail = [UserPsychologyDetail mj_objectWithKeyValues:dicResp];
        
        _taskResult = detail;

        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}


@end

@implementation ReportPsychologyTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postCommonHealthyPlanServiceUrl:@"addUserMoodRecord"];
    return postUrl;
}

@end
