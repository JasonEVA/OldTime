//
//  UserAppointmentListTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/30.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "UserAppointmentListTask.h"
#import "AppointmentInfo.h"

@implementation UserAppointmentListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postAppointmetnServiceUrl:@"getStaffUserAppoint"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSNumber* numCount = [dicResp valueForKey:@"count"];
        NSArray* lstResp = [dicResp valueForKey:@"list"];
        NSMutableArray* appointItems = [NSMutableArray array];
        if (lstResp && [lstResp isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicAppoint in lstResp)
            {
                AppointmentInfo* appointment = [AppointmentInfo mj_objectWithKeyValues:dicAppoint];
                [appointItems addObject:appointment];
            }
        }
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        [dicResult setValue:appointItems forKey:@"list"];
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        
        _taskResult = dicResult;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
    
}

@end

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
