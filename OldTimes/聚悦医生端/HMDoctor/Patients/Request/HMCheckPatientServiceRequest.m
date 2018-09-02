//
//  HMCheckPatientServiceRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2017/2/22.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMCheckPatientServiceRequest.h"

@implementation HMCheckPatientServiceRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServicePoServiceUrl:@"checkUserIsOrderService"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        _taskResult = stepResult;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
