//
//  AppointmentDetailTask.m
//  HMClient
//
//  Created by yinqaun on 16/5/30.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppointmentDetailTask.h"
#import "AppointmentInfo.h"

@implementation AppointmentDetailTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postAppointmetnServiceUrl:@"getMcAppointById"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        AppointmentDetail* detail = [AppointmentDetail mj_objectWithKeyValues:dicResp];
        _taskResult = detail;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";

}

@end

@implementation AppointmentCancelTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postAppointmetnServiceUrl:@"userApplyCancelAppoint"];
    return postUrl;
}

@end
