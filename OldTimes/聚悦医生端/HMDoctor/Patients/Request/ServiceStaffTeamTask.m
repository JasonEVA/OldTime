//
//  ServiceStaffTeamTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ServiceStaffTeamTask.h"

@implementation ServiceStaffTeamTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrgTeamServiceUrl:@"getUserServiceTeamByUserId"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        
        NSArray* lstResp = [dicResp valueForKey:@"orgTeamDet"];
        NSMutableArray* staffs = [NSMutableArray array];
        
        if (lstResp && [lstResp isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicStaff in lstResp)
            {
                StaffInfo* staff = [StaffInfo mj_objectWithKeyValues:dicStaff];
                [staffs addObject:staff];
            }
        }
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        
        NSNumber* numTeamId = [dicResp valueForKey:@"teamId"];
        if (numTeamId && [numTeamId isKindOfClass:[NSNumber class]])
        {
            [dicResult setValue:numTeamId forKey:@"teamId"];
        }
        
        NSNumber* numTeamStaff = [dicResp valueForKey:@"teamStaffId"];
        if (numTeamStaff && [numTeamStaff isKindOfClass:[NSNumber class]])
        {
            [dicResult setValue:numTeamStaff forKey:@"teamStaffId"];
        }
        [dicResult setValue:staffs forKey:@"list"];
        _taskResult = dicResult;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"获取用户的服务信息失败。";
}

@end

