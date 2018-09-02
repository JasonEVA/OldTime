//
//  HMCheckChatStatusRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/10/26.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMCheckChatStatusRequest.h"

@implementation HMCheckChatStatusRequest
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postAppPatients:@"checkIMSession"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]] && stepResult) {
        _taskResult = stepResult;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
