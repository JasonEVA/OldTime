//
//  HMGetStepHistoryRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/8/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMGetStepHistoryRequest.h"
#import "HMStepHistoryModel.h"

@implementation HMGetStepHistoryRequest
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postExerciseService:@"getStepDiagramData"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult[@"list"];
    if ([stepResult isKindOfClass:[NSArray class]] && stepResult) {
        NSArray *result = [HMStepHistoryModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = result;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
