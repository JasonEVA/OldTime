//
//  ServiceDetailTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/1.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ServiceDetailTask.h"
#import "ServiceInfo.h"

@implementation ServiceDetailTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrderServiceUrl:@"prePlaceOrder"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        ServiceDetail* detail = [ServiceDetail mj_objectWithKeyValues:dicResp];
        _taskResult = detail;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
