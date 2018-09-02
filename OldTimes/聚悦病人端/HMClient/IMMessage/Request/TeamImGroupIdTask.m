//
//  TeamImGroupIdTask.m
//  HMClient
//
//  Created by yinqaun on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
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
    _taskErrorMessage = @"服务器数据访问失败，无法获取会话消息。";
}
@end
