//
//  UpdateStaffInfoTask.m
//  HMDoctor
//
//  Created by yinquan on 2017/7/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "UpdateStaffInfoTask.h"

@implementation UpdateStaffInfoTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postStaffServiceUrl:@"updateStaffUserInfo"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = [stepResult valueForKey:@"result"];
        StaffInfo* staff = [StaffInfo mj_objectWithKeyValues:dicResp];
        [[UserInfoHelper defaultHelper] saveStaffInfo:staff];
        //UserInfo* userInfo = [UserInfo mj_objectWithKeyValues:dicResp];
        //[[UserInfoHelper defaultHelper] saveUserInfo:userInfo];
        _taskResult = staff;
        return;
    }

    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
