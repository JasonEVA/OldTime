//
//  HMGetUserExercisePKlistRequest.m
//  HMClient
//
//  Created by JasonWang on 2017/5/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMGetUserExercisePKlistRequest.h"
#import "HMExercisePKModel.h"

@implementation HMGetUserExercisePKlistRequest
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postExerciseService:@"getUserExercisePKList"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]] && stepResult) {
        NSArray *result = [HMExercisePKModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = result;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
