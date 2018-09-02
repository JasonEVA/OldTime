//
//  HMSecondEditionSSMSRequest.m
//  HMClient
//
//  Created by jasonwang on 2016/11/28.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMSecondEditionSSMSRequest.h"
#import "HMPingAnPayOrderModel.h"
@implementation HMSecondEditionSSMSRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postePayService:@"unionSSMS"];
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
