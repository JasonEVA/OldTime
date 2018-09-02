//
//  UserSportsDetailTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/14.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserSportsDetailTask.h"
#import "UserSportsDetail.h"

@implementation UserSportsDetailTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postCommonHealthyPlanServiceUrl:@"getUserSports"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        UserSportsDetail* detail = [UserSportsDetail mj_objectWithKeyValues:dicResp];
        
        _taskResult = detail;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
