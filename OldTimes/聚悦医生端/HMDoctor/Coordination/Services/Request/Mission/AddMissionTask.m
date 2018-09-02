//
//  AddMissionTask.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AddMissionTask.h"

@implementation AddMissionTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postWorkTaskServiceUrl:@"addTask"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    _taskResult = stepResult;
}

@end
