//
//  DoctorGreetingTask.m
//  HMClient
//
//  Created by lkl on 16/6/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DoctorGreetingTask.h"
#import "DoctorGreetingInfo.h"

@implementation DoctorGreetingTask

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
            DoctorGreetingInfo* greetingInfo = [DoctorGreetingInfo mj_objectWithKeyValues:dicCare];
            [cares addObject:greetingInfo];
        }
        _taskResult = cares;
        
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end

@implementation markCareReadedTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"markCareReaded"];
    return postUrl;
}

@end
