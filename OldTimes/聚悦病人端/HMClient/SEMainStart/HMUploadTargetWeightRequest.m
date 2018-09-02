//
//  HMUploadTargetWeightRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/8/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMUploadTargetWeightRequest.h"

@implementation HMUploadTargetWeightRequest
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postExerciseService:@"addUserExerTZAim"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]] && stepResult) {
//        NSArray *result = [HMLoseWeightPkModel mj_objectArrayWithKeyValuesArray:stepResult];
//        _taskResult = result;
//        return;
    }
//    _taskError = StepError_NetwordDataError;
//    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
