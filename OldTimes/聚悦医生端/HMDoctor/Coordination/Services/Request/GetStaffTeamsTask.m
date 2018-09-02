//
//  GetStaffTeamsTask.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GetStaffTeamsTask.h"
#import "ServiceGroupTeamInfoModel.h"

#import "StaffTeamDoctorModel.h"



@implementation GetStaffTeamsTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrgTeamServiceUrl:@"getStaffTeams"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray *array = [ServiceGroupTeamInfoModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = array;
    }
}

@end

@implementation GetStaffTeamDoctorTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrgTeamServiceUrl:@"getUserTeamStaff"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray *array = [StaffTeamDoctorModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = array;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end

@implementation GetUserTeamStaffByFunctionCodeTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"getUserTeamStaffByFunctionCode"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray *array = [StaffTeamDoctorModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = array;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
