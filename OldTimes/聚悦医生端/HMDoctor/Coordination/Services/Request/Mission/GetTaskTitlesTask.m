//
//  GetTaskTitlesTask.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GetTaskTitlesTask.h"

@implementation GetTaskTitlesTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postWorkTaskServiceUrl:@"getTaskTitles"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    _taskResult = stepResult;
}

@end
