//
//  HMSendConcernToGroupsOrPatientsRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2017/6/14.
//  Copyright © 2017年 yinquan. All rights reserved.
//  新版群发接口，可发给个人或者群组

#import "HMSendConcernToGroupsOrPatientsRequest.h"

@implementation HMSendConcernToGroupsOrPatientsRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"batchSendUserCare"];
    return postUrl;
}

//- (void) makeTaskResult
//{
//    id stepResult = currentStep.stepResult;
//    
////    if ([stepResult isKindOfClass:[NSDictionary class]]) {
////        NSDictionary* respDictionary = (NSDictionary*) stepResult;
////        MainConsoleFunctionRetModel* statiscticsRetModel = [MainConsoleFunctionRetModel mj_objectWithKeyValues:respDictionary];
////        _taskResult = statiscticsRetModel;
////        return;
////    }
////    
////    _taskErrorMessage = @"接口数据访问失败。";
////    _taskError = StepError_NetwordDataError;
//}
@end
