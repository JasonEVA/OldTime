//
//  PointRedemptionContinuationTask.m
//  HMClient
//
//  Created by yinquan on 2017/7/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PointRedemptionContinuationTask.h"
#import "AttendanceSummaryModel.h"

@implementation PointRedemptionContinuationTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postAttendanceServiceUrl:@"getAttendanceInfo"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        AttendanceSummaryModel* model = [AttendanceSummaryModel mj_objectWithKeyValues:dicResp];
        [[UserInfoHelper defaultHelper] setLastSignedDate:model.attendanceTime];
        _taskResult = model;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
