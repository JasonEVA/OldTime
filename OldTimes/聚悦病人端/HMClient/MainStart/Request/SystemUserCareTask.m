//
//  SystemUserCareTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SystemUserCareTask.h"
#import "UserCareInfo.h"

@implementation SystemUserCareTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postSystemServiceUrl:@"getSystemUserCare"];
    return postUrl;
}
         
- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*) stepResult;
        NSMutableArray* cares = [NSMutableArray array];
        for (NSDictionary* dicCare in lstResp)
        {
            UserCareInfo* userCare = [UserCareInfo mj_objectWithKeyValues:dicCare];
            [cares addObject:userCare];
        }
         _taskResult = cares;
        
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end

@implementation StaffUserCareTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"getUnReadUserCare"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*) stepResult;
        NSMutableArray* cares = [NSMutableArray array];
        for (NSDictionary* dicCare in lstResp)
        {
            UserCareInfo* userCare = [UserCareInfo mj_objectWithKeyValues:dicCare];
            [cares addObject:userCare];
        }
        _taskResult = cares;
        
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
