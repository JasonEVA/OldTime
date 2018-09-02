//
//  PEFDetectResultTask.m
//  HMClient
//
//  Created by lkl on 2017/6/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PEFDetectResultTask.h"
#import "PEFResultModel.h"

@implementation PEFDetectResultTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataService:@"getTodayFlsz"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if (stepResult && [stepResult isKindOfClass:[NSDictionary class]])
    {
        PEFResultModel *model = [PEFResultModel mj_objectWithKeyValues:stepResult];
        _taskResult = model;
        
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
