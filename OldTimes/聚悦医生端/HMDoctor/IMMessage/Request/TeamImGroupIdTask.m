//
//  TeamImGroupIdTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "TeamImGroupIdTask.h"

@implementation TeamImGroupIdTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"getUserTeamImGroupId"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSString class]])
    {
        _taskResult = (NSString*) stepResult;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
