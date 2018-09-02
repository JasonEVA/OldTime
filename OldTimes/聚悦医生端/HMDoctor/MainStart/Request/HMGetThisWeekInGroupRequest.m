//
//  HMGetThisWeekInGroupRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2017/8/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMGetThisWeekInGroupRequest.h"

@implementation HMGetThisWeekInGroupRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postWorkBenchPatientServiceURL:@"getPatientListThisWeek"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;

    if ([stepResult isKindOfClass:[NSDictionary class]]) {
        _taskResult = stepResult;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
