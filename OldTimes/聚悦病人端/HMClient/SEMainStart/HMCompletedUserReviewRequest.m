//
//  HMCompletedUserReviewRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/5/18.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMCompletedUserReviewRequest.h"

@implementation HMCompletedUserReviewRequest
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postAppPatients:@"completedUserReview"];
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
