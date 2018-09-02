//
//  NewSiteMessageGetMessageWithTypeRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/1/16.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewSiteMessageGetMessageWithTypeRequest.h"
#import "SiteMessageLastMsgModel.h"

@implementation NewSiteMessageGetMessageWithTypeRequest
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postPatientMsgService:@"getPatientMsg"];
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
