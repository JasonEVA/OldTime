//
//  NewSiteMessageGetSurveryStatusRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/2/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewSiteMessageGetSurveryStatusRequest.h"
#import "NewSiteMessageRoundsStatusModel.h"

@implementation NewSiteMessageGetSurveryStatusRequest

- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postSurveryServiceUrl:@"getSurveyResultStatus"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]] && stepResult) {
        NewSiteMessageRoundsStatusModel *result = [NewSiteMessageRoundsStatusModel mj_objectWithKeyValues:stepResult];
        _taskResult = result;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
