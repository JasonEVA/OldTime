//
//  AppendActionStatTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppendActionStatTask.h"

@implementation AppendActionStatTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postActionStatServiceUrl:@"addActionStat"];
    return postUrl;
}

- (void)makeTaskResult {
    
}
@end

@implementation PicServierPathTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postSystemServiceUrl:@"getPicServcerPath"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSString class]])
    {
        _taskResult = stepResult;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}


@end
