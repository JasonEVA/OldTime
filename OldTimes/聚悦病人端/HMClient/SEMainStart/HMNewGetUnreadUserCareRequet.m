//
//  HMNewGetUnreadUserCareRequet.m
//  HMClient
//
//  Created by jasonwang on 2017/6/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMNewGetUnreadUserCareRequet.h"
#import "DoctorGreetingInfo.h"

@implementation HMNewGetUnreadUserCareRequet
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"getUnReadUserCare"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]] && stepResult) {
        NSArray *result = [DoctorGreetingInfo mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = result;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
