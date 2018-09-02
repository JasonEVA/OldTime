//
//  PatientListTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientListTask.h"
#import "PatientInfo.h"

@implementation PatientListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServicePoServiceUrl:@"getStaffPatientService"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*)stepResult;
        NSMutableArray* groups = [NSMutableArray array];
        for (NSDictionary* dicGorup in lstResp)
        {
            PatientGroupInfo* group = [PatientGroupInfo mj_objectWithKeyValues:dicGorup];
            [groups addObject:group];
        }
        
        if (0 < groups.count) {
            PatientGroupInfo* group = [groups firstObject];
            group.isExpanded = YES;
        }
        
        _taskResult = groups;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
