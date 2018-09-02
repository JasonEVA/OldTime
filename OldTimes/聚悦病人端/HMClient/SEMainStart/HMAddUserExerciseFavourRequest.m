//
//  HMAddUserExerciseFavourRequest.m
//  HMClient
//
//  Created by JasonWang on 2017/5/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMAddUserExerciseFavourRequest.h"

@implementation HMAddUserExerciseFavourRequest
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postExerciseService:@"addUserExerciseFavour"];
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
