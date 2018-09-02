//
//  OrderPayInfoTask.m
//  HMClient
//
//  Created by yinqaun on 16/5/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OrderPayInfoTask.h"

@implementation OrderPayInfoTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrderServiceUrl:@"choosePayWayUpgrade"];
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
