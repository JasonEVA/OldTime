//
//  ServiceHasAppointStaffsTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceHasAppointStaffsTask.h"

@implementation ServiceHasAppointStaffsTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper posuserServicePoServiceUrl:@"getUserServiceHasAppointStaffs"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*)stepResult;
        NSMutableArray* staffs = [NSMutableArray array];
        for (NSDictionary* dicStaff in lstResp)
        {
            StaffInfo* staff = [StaffInfo mj_objectWithKeyValues:dicStaff];
            [staffs addObject:staff];
        }
        _taskResult = staffs;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
    
}


@end
