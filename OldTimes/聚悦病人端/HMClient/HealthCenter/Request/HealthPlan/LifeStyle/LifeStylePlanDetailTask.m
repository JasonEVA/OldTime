//
//  LifeStylePlanDetailTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "LifeStylePlanDetailTask.h"
#import "UserLifeStyleDetail.h"

@implementation LifeStylePlanDetailTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postCommonHealthyPlanServiceUrl:@"getUserLive"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        UserLifeStyleDetail* detail = [UserLifeStyleDetail mj_objectWithKeyValues:dicResp];
        
        _taskResult = detail;
        
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
