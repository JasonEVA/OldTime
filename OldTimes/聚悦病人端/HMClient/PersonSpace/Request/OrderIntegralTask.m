//
//  OrderIntegralTask.m
//  HMClient
//
//  Created by yinquan on 2017/7/18.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "OrderIntegralTask.h"

@implementation OrderIntegralTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postIntegralServiceUrl:@"getOrderIntegral"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* respDict = (NSDictionary*)stepResult;
        NSNumber* integralNumber = [respDict valueForKey:@"integral"];
        _taskResult = integralNumber;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
