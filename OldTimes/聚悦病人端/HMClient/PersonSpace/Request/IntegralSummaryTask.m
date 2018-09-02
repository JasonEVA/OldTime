//
//  IntegralSummaryTask.m
//  HMClient
//
//  Created by yinquan on 2017/7/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "IntegralSummaryTask.h"
#import "IntegralModel.h"
@implementation IntegralSummaryTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postIntegralServiceUrl:@"getUserIntegralInfoVO"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if (!stepResult || ([stepResult isKindOfClass:[NSString class]] && [stepResult isEqualToString:@""])) {
        stepResult = [NSDictionary dictionary];
    }
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        IntegralSummaryModel* model = [IntegralSummaryModel mj_objectWithKeyValues:dicResp];
        
        _taskResult = model;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
