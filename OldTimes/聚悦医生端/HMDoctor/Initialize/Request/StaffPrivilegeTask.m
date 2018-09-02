//
//  StaffPrivilegeTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "StaffPrivilegeTask.h"

@implementation StaffPrivilegeTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"getDocPrivilege"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        _taskResult = stepResult;
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        [StaffPrivilegeHelper savePrivilege:dicResp];
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
