//
//  HMSecondEditionPaySubmitRequest.m
//  HMClient
//
//  Created by jasonwang on 2016/11/28.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMSecondEditionPaySubmitRequest.h"

@implementation HMSecondEditionPaySubmitRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postePayService:@"unionSubmit"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]]) {
        _taskResult = stepResult;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器接口调用失败。";
}
@end
