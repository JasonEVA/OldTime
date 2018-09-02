//
//  ServiceDetDetailTask.m
//  HMClient
//
//  Created by yinquan on 16/11/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceDetDetailTask.h"
#import "OrderedServiceModel.h"

@implementation ServiceDetDetailTask


- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper posuserServicePoServiceUrl:@"getUserServiceDetInfoById"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        
        UserServiceDet* serviceDet = [UserServiceDet mj_objectWithKeyValues:dicResp];
        _taskResult = serviceDet;
        _taskError = StepError_None;
        _taskErrorMessage = currentStep.stepErrorMessage;
        return;

    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器接口调用失败。";
}

@end
