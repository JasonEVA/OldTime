//
//  GetWorkBenchPatientListTask.m
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GetWorkBenchPatientListTask.h"
#import "NewPatientListInfoModel.h"

@implementation GetWorkBenchPatientListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postWorkBenchPatientServiceURL:@"findStaffPatientList"];
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
