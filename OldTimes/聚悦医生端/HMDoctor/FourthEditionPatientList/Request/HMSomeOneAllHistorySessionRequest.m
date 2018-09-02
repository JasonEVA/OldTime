//
//  HMSomeOneAllHistorySessionRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2017/10/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMSomeOneAllHistorySessionRequest.h"
#import "NewPatientListInfoModel.h"

@implementation HMSomeOneAllHistorySessionRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postWorkBenchPatientServiceURL:@"findStaffHistoryPatientSession"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSArray *patientResult = stepResult[@"list"];
        if (patientResult && [patientResult isKindOfClass:[NSArray class]]) {
            NSArray<NewPatientListInfoModel *> *result = [NewPatientListInfoModel mj_objectArrayWithKeyValuesArray:patientResult];
            _taskResult = result;
        }
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
