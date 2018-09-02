//
//  GetUserServiceComplainTypesTask.m
//  HMClient
//
//  Created by Dee on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "GetUserServiceComplainTypesTask.h"

@implementation GetUserServiceComplainTypesTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper posuserServicePoServiceUrl:@"getUserServiceComplainTypes"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    _taskResult = stepResult;
}


@end
