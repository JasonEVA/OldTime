//
//  UserServiceStatusTask.m
//  HMClient
//
//  Created by yinqaun on 16/8/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserServiceStatusTask.h"

@implementation UserServiceStatusTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper posuserServicePoServiceUrl:@"getUserServiceStatusData"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if (stepResult && [stepResult isKindOfClass:[NSDictionary class]])
    {
        _taskResult = stepResult;
        return;
    }
    
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
