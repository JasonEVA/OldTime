//
//  HMGetTrendDataRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/6/9.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMGetTrendDataRequest.h"

@implementation HMGetTrendDataRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postMonitorService:@"getTrendData"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* dicResp = (NSArray*) stepResult;
        _taskError = StepError_None;
        _taskResult = dicResp;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
