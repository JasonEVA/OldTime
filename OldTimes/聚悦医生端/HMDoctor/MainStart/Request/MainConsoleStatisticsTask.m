//
//  MainConsoleStatisticsTask.m
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "MainConsoleStatisticsTask.h"
#import "MainConsoleStatisticsModel.h"

@implementation MainConsoleStatisticsTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postStaffServiceUrl:@"getDoctorPatientCount"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if ([stepResult isKindOfClass:[NSDictionary class]]) {
        NSDictionary* respDictionary = (NSDictionary*) stepResult;
        MainConsoleStatisticsModel* statiscticsModel = [MainConsoleStatisticsModel mj_objectWithKeyValues:respDictionary];
        _taskResult = statiscticsModel;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
