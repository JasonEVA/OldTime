//
//  IntegralSourceRecordsListTask.m
//  HMClient
//
//  Created by yinquan on 2017/7/17.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "IntegralSourceRecordsListTask.h"
#import "IntegralRecordModel.h"

@implementation IntegralSourceRecordsListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postIntegralServiceUrl:@"findUserIntegralDetails"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        IntegralSourceRecordModel* srouceModel = [IntegralSourceRecordModel mj_objectWithKeyValues:stepResult];
        _taskResult = srouceModel;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
