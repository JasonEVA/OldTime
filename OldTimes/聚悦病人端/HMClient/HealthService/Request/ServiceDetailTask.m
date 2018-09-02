//
//  ServiceDetailTask.m
//  HMClient
//
//  Created by yinqaun on 16/5/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceDetailTask.h"
#import "ServiceInfo.h"
#import "ServiceNeedMsg.h"

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

@implementation ServiceNeedMsgsTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrderServiceUrl:@"getNeedMsgs"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if (!stepResult || ![stepResult isKindOfClass:[NSArray class]])
    {
        return;
    }
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*) stepResult;
        NSMutableArray* needMsgItems = [NSMutableArray array];
        for (NSDictionary* dic in lstResp)
        {
            ServiceNeedMsg* needMsg = [ServiceNeedMsg mj_objectWithKeyValues:dic];
            [needMsgItems addObject:needMsg];
        }
        
        _taskResult = needMsgItems;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
