//
//  NewSiteMessagechangeRemindStatusRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/3/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewSiteMessagechangeRemindStatusRequest.h"
#import "SiteMessageSecondEditionMainListModel.h"

@implementation NewSiteMessagechangeRemindStatusRequest
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postPatientMsgService:@"updatePatientMsgStatus"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]] && stepResult) {
        NSArray *array = [SiteMessageSecondEditionMainListModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = array;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
