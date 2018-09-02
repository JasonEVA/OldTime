//
//  SetRemindTimeTask.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "SetRemindTimeTask.h"

@implementation SetRemindTimeTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postWorkTaskServiceUrl:@"setRemind"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    _taskResult = stepResult;
}

@end
