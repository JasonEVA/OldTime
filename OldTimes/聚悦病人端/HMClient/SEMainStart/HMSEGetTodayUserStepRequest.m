//
//  HMSEGetTodayUserStepRequest.m
//  HMClient
//
//  Created by lkl on 2017/10/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSEGetTodayUserStepRequest.h"
#import "HMSEGetTodayUserStepModel.h"

@implementation HMSEGetTodayUserStepRequest

- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postExerciseService:@"getTodayUserStep"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]] && stepResult) {
        HMSEGetTodayUserStepModel *model = [HMSEGetTodayUserStepModel mj_objectWithKeyValues:stepResult];
        _taskResult = model;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end

@implementation AddUserBraceletDataTask : SingleHttpRequestTask

- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataService:@"addUserBraceletData"];
    return postUrl;
}
@end
