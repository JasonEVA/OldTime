//
//  HMAddUserExerciseRequest.m
//  HMClient
//
//  Created by JasonWang on 2017/5/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMAddUserExerciseRequest.h"

@implementation HMAddUserExerciseRequest
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postExerciseService:@"addUserExercise"];
    return postUrl;
}

- (void)makeTaskResult
{
    if (currentStep.stepError == StepError_None) {
        _taskResult = @"成功";
        return;
    }
    
}

@end
