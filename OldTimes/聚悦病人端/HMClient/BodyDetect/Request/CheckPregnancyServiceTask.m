//
//  CheckPregnancyServiceTask.m
//  HMClient
//
//  Created by yinquan on 17/3/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "CheckPregnancyServiceTask.h"

@implementation CheckPregnancyServiceTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postWeightTestServiceUrl:@"checkService"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if (stepResult && [stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSNumber* num = [dicResp valueForKey:@"num"];
        if (num && [num isKindOfClass:[NSNumber class]])
        {
            _taskResult = num;
            _taskError = StepError_None;
        }
        else
        {
            _taskErrorMessage = @"接口数据访问失败。";
            _taskError = StepError_NetwordDataError;
        }
        
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
