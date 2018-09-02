//
//  NewSiteMessageGetAssessStatusRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/2/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewSiteMessageGetAssessStatusRequest.h"
#import "NewSiteMessageGetAssessStatusModel.h"

@implementation NewSiteMessageGetAssessStatusRequest

- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postSurveryServiceUrl:@"getSurveyRecordStatus"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]] && stepResult) {
        NewSiteMessageGetAssessStatusModel *result = [NewSiteMessageGetAssessStatusModel mj_objectWithKeyValues:stepResult];
        _taskResult = result;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
