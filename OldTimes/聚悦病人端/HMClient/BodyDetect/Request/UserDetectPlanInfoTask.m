//
//  UserDetectPlanInfoTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserDetectPlanInfoTask.h"
#import "DetectPlanInfo.h"
@implementation UserDetectPlanInfoTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataService:@"getUserTestTask"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if (stepResult && [stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        DetectPlanInfo* planInfo = [DetectPlanInfo mj_objectWithKeyValues:dicResp];
        
        _taskResult = planInfo;
        
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
