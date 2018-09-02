//
//  ShareProductTask.m
//  HMDoctor
//
//  Created by yinquan on 2017/6/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "ShareProductTask.h"

@implementation ShareProductTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postProductService:@"shareProduct"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if (stepResult && [stepResult isKindOfClass:[NSString class]]) {
        _taskResult = stepResult;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
