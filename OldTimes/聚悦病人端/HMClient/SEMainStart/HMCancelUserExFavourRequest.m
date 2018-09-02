//
//  HMCancelUserExFavourRequest.m
//  HMClient
//
//  Created by JasonWang on 2017/5/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMCancelUserExFavourRequest.h"

@implementation HMCancelUserExFavourRequest
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postExerciseService:@"cancelUserExerciseFavour"];
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
