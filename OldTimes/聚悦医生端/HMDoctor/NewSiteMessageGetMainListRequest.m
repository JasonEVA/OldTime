//
//  NewSiteMessageGetMainListRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/1/16.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewSiteMessageGetMainListRequest.h"
#import "SiteMessageSecondEditionMainListModel.h"

@implementation NewSiteMessageGetMainListRequest
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postDoctorMsgService:@"getUnReadPatientMsgType"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]] && stepResult) {
        NSArray<SiteMessageSecondEditionMainListModel *> *result = [SiteMessageSecondEditionMainListModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = result;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
