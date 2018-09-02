//
//  SESiteMessageGetMessageListWithTypeRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2017/9/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SESiteMessageGetMessageListWithTypeRequest.h"
#import "SiteMessageLastMsgModel.h"

@implementation SESiteMessageGetMessageListWithTypeRequest
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postDoctorMsgService:@"getPatientMsg"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]] && stepResult) {
        NSArray<SiteMessageLastMsgModel *> *result = [SiteMessageLastMsgModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = result;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
