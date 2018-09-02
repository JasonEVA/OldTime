//
//  AppointmentApplyTask.m
//  HMClient
//
//  Created by yinqaun on 16/5/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppointmentApplyTask.h"
#import "AppointStaffModel.h"

@implementation AppointmentApplyTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postAppointmetnServiceUrl:@"userAppointment2"];
    return postUrl;
}

@end

@implementation AppointmentStaffListTask



- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper posuserServicePoServiceUrl:@"getUserAppointStaffList"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]]) {
        NSArray* lstResp = (NSArray*) stepResult;
        NSMutableArray* staffList = [NSMutableArray array];
        
        [lstResp enumerateObjectsUsingBlock:^(NSDictionary*  dicCate, NSUInteger idx, BOOL * _Nonnull stop) {
            AppointStaffModel* model = [AppointStaffModel mj_objectWithKeyValues:dicCate];
            
            [staffList addObject:model];
        }];
        _taskResult = staffList;
        _taskError = StepError_None;
        _taskErrorMessage = currentStep.stepErrorMessage;
        return;
    }
    
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器接口调用失败。";
}
@end

@implementation AppointmentStaffCountTask

- (NSString*) postUrl
{
    NSString* postUrl =[ClientHelper posuserServicePoServiceUrl:@"getUserAppointStaffCount"];

    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        _taskResult = stepResult;
        _taskError = StepError_None;
        _taskErrorMessage = currentStep.stepErrorMessage;
        return;
    }
    
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器接口调用失败。";
}

@end
