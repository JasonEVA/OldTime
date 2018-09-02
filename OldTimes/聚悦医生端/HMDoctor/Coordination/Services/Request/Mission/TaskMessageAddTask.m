//
//  TaskMessageAddTask.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "TaskMessageAddTask.h"

@implementation TaskMessageAddTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postWorkTaskServiceUrl:@"taskMessageAdd"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    _taskResult = stepResult;
}

@end
