//
//  SingleHttpRequestTask.m
//  HealthManagerDoctorDemo
//
//  Created by yinqaun on 16/1/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SingleHttpRequestTask.h"
#import "JsonHttpStep.h"


@implementation SingleHttpRequestTask

- (Step*) createFristStep
{
    NSString* postUrl = [self postUrl];
    if (postUrl)
    {
        JsonHttpStep* step = [[JsonHttpStep alloc]initWithUrl:postUrl Params:taskParam];
        return step;
    }
    return nil;
}

- (NSString*) postUrl
{
    return nil;
}

- (void) makeTaskResult
{
    _taskResult = currentStep.stepResult;
}
@end
