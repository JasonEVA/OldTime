//
//  StaffDetailTask.m
//  HMClient
//
//  Created by yinqaun on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "StaffDetailTask.h"
#import "StaffDetail.h"
#import "TeamInfo.h"
#import "ServiceInfo.h"

@implementation StaffDetailTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postStaffServiceUrl:@"getStaffInfo"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        StaffDetail* detail = [StaffDetail mj_objectWithKeyValues:dicResp];
        _taskResult = detail;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end

@implementation StaffTeamsTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrgTeamServiceUrl:@"getStaffTeams"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstDict = (NSArray*) stepResult;
        
        if (lstDict && [lstDict isKindOfClass:[NSArray class]])
        {
            NSMutableArray* teamlist = [NSMutableArray array];
            
            for (NSDictionary* dicTeam in lstDict)
            {
                TeamInfo* team = [TeamInfo mj_objectWithKeyValues:dicTeam];
                [teamlist addObject:team];
            }
            _taskResult = teamlist;
            return;
            
        }
        
        
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end

@implementation StaffServicesTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper posuserServicePoServiceUrl:@"getStaffProviderService"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstDict = (NSArray*) stepResult;
        
        if (lstDict && [lstDict isKindOfClass:[NSArray class]])
        {
            NSMutableArray* servicelist = [NSMutableArray array];
            
            for (NSDictionary* dicService in lstDict)
            {
                ServiceInfo* team = [ServiceInfo mj_objectWithKeyValues:dicService];
                [servicelist addObject:team];
            }
            _taskResult = servicelist;
            return;
            
        }
        
        
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
