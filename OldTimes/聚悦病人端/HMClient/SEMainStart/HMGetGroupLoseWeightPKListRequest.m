//
//  HMGetGroupLoseWeightPKListRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/8/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMGetGroupLoseWeightPKListRequest.h"
#import "HMLoseWeightPkModel.h"

@implementation HMGetGroupLoseWeightPKListRequest
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postExerciseService:@"getUserExerciseTZPKList"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult[@"list"];
    if ([stepResult isKindOfClass:[NSArray class]] && stepResult) {
        NSArray *result = [HMLoseWeightPkModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = result;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
