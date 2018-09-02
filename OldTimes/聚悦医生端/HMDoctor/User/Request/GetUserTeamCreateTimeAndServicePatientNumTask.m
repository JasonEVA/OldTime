//
//  GetUserTeamCreateTimeAndServicePatientNumTask.m
//  HMDoctor
//
//  Created by kylehe on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GetUserTeamCreateTimeAndServicePatientNumTask.h"
#import "StaffServiceInfoModel.h"
#import "NSDictionary+SafeManager.h"
static NSString *const create_time = @"CREATE_TIME";
static NSString *const service_num = @"SERVUCE_NUM";
static NSString *const all_num = @"ALL_NUM";


@implementation GetUserTeamCreateTimeAndServicePatientNumTask

- (NSString *) postUrl
{
    NSString *postUrl = [ClientHelper postOrgTeamServiceUrl:@"getUserTeamCreateTimeAndServicePatiendNum"];
    return postUrl;
}

- (void)makeTaskResult
{
    if ([currentStep.stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary * stepResult = currentStep.stepResult;
        if (stepResult.count)
        {
            StaffServiceInfoModel *model  = [[StaffServiceInfoModel alloc] init];
            model.createTime = [stepResult valueStringForKey:create_time];
            model.serviceNum = [stepResult valueNumberForKey:service_num];
            model.allNum = [stepResult valueNumberForKey:all_num];
            _taskResult = model;
        }
    }
}

@end
