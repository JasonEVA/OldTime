
//
//  HMSEMainStartHomeRequest.m
//  HMClient
//
//  Created by JasonWang on 2017/5/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSEMainStartHomeRequest.h"
#import "HMHomeModel.h"
#import "HMAdsModel.h"

@implementation HMSEMainStartHomeRequest
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postAppPatients:@"home"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]] && stepResult) {
        HMHomeModel *result = [HMHomeModel mj_objectWithKeyValues:stepResult];
        result.adsModelArr = [HMAdsModel mj_objectArrayWithKeyValuesArray:result.ads[@"ad"]];
        
        _taskResult = result;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
