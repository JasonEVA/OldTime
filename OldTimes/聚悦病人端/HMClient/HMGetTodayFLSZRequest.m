//
//  HMGetTodayFLSZRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/7/21.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMGetTodayFLSZRequest.h"
#import "PEFResultModel.h"

@implementation HMGetTodayFLSZRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataService:@"getDayFlsz"];
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
