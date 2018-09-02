//
//  UserServiceEvaluateTask.m
//  HMClient
//
//  Created by Dee on 16/6/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//  用户评价

#import "UserServiceEvaluateTask.h"

@implementation UserServiceEvaluateTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postuserServiceEvaluateURL:@"addUserServiceEvaluate"];
    return postUrl;
}

//- (void) makeTaskResult
//{
//    id stepResult = currentStep.stepResult;
//    if ([stepResult isKindOfClass:[NSDictionary class]])
//    {
//        NSDictionary* dicResp = (NSDictionary*) stepResult;
//        AppointmentDetail* detail = [AppointmentDetail mj_objectWithKeyValues:dicResp];
//        _taskResult = detail;
//        return;
//    }
//    _taskError = StepError_NetwordDataError;
//    _taskErrorMessage = @"服务器数据访问失败。";
//    
//}
@end
