//
//  GetUserServiceByCompTypeTask.m
//  HMClient
//
//  Created by Dee on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "GetUserServiceByCompTypeTask.h"

@implementation GetUserServiceByCompTypeTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper posuserServicePoServiceUrl:@"getUserServiceByCompType"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResutl = currentStep.stepResult;
    _taskResult = stepResutl;
}

@end
