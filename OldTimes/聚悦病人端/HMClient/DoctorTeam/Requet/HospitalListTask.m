//
//  HospitalListTask.m
//  HMClient
//
//  Created by yinqaun on 16/5/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HospitalListTask.h"
#import "HosipitalInfo.h"

@implementation HospitalListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrgServiceUrl:@"getIsProviderOrg"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*)stepResult;
        NSMutableArray* hosipitalItems = [NSMutableArray array];
        for (NSDictionary* dicHosipital in lstResp) {
            HosipitalInfo* hosipital = [HosipitalInfo mj_objectWithKeyValues:dicHosipital];
            [hosipitalItems addObject:hosipital];
        }
        _taskResult = hosipitalItems;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end

@implementation DepartmentListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postDepServiceUrl:@"getDepByOrgId"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*)stepResult;
        NSMutableArray* hosipitalItems = [NSMutableArray array];
        for (NSDictionary* dicHosipital in lstResp) {
            DepartmentInfo* hosipital = [DepartmentInfo mj_objectWithKeyValues:dicHosipital];
            [hosipitalItems addObject:hosipital];
        }
        _taskResult = hosipitalItems;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
