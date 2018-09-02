//
//  NuritionPlanDetailTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NuritionPlanDetailTask.h"
#import "NuritionDetail.h"

@implementation NuritionPlanDetailTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postCommonHealthyPlanServiceUrl:@"getUserNurition"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NuritionDetail* detail = [NuritionDetail mj_objectWithKeyValues:dicResp];
        
        _taskResult = detail;

        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
