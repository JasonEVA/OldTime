//
//  HMSecondEditionGetCardListRequest.m
//  HMClient
//
//  Created by jasonwang on 2016/11/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMSecondEditionGetCardListRequest.h"
#import "HMPingAnPayCardModel.h"
@implementation HMSecondEditionGetCardListRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postePayService:@"unionOpened"];
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
