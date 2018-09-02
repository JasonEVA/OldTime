//
//  TeamListTask.m
//  HMClient
//
//  Created by yinqaun on 16/5/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "TeamListTask.h"
#import "TeamInfo.h"

@implementation TeamListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrgTeamServiceUrl:@"getOrgTeams"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSNumber* numCount = [dicResp valueForKey:@"count"];
        NSArray* lstDict = [dicResp valueForKey:@"list"];
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        
        if (lstDict && [lstDict isKindOfClass:[NSArray class]])
        {
            NSMutableArray* teamlist = [NSMutableArray array];
            
            for (NSDictionary* dicRecord in lstDict)
            {
                TeamInfo* team = [TeamInfo mj_objectWithKeyValues:dicRecord];
                [teamlist addObject:team];
            }
            [dicResult setValue:teamlist forKey:@"list"];
        }
        
        _taskResult = dicResult;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end

@implementation TeamDetailTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrgTeamServiceUrl:@"getOrgTeamByTeamId"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        TeamDetail* detail = [TeamDetail mj_objectWithKeyValues:dicResp];
        _taskResult = detail;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
