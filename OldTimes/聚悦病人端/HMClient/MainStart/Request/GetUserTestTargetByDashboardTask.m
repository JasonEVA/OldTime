//
//  GetUserTestTargetByDashboardTask.m
//  HMClient
//
//  Created by Andrew Shen on 2016/11/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "GetUserTestTargetByDashboardTask.h"
#import "MainStartHealthTargetModel.h"

@implementation GetUserTestTargetByDashboardTask

- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postHealthPlan2Service:@"getUserTestTargetByDashboard"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]] && stepResult) {
        NSArray<MainStartHealthTargetModel *> *result = [MainStartHealthTargetModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = result;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
