//
//  IntegralChangeTask.m
//  HMClient
//
//  Created by yinquan on 2017/7/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "IntegralChangeTask.h"
#import "IntegralModel.h"

@implementation IntegralChangeTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postIntegralServiceUrl:@"changeIntegral"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        IntegralModel* model = [IntegralModel mj_objectWithKeyValues:dicResp];
        
        _taskResult = model;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
