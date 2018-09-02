//
//  HMConcernAcquireListRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2016/12/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMConcernAcquireListRequest.h"
#import "HMConcernModel.h"

@implementation HMConcernAcquireListRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"getHistoryCare"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if ([stepResult[@"list"] isKindOfClass:[NSArray class]]) {
        _taskResult = [HMConcernModel mj_objectArrayWithKeyValuesArray:stepResult[@"list"]];
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
