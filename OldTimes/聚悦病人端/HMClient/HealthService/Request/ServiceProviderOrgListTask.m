//
//  ServiceProviderOrgListTask.m
//  HMClient
//
//  Created by yinquan on 16/12/12.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceProviderOrgListTask.h"
#import "HosipitalInfo.h"

@implementation ServiceProviderOrgListTask


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

@implementation ServiceProviderDeptListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postDepServiceUrl:@"getIsProviderDep"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*)stepResult;
        NSMutableArray* departItems = [NSMutableArray array];
        for (NSDictionary* dicDepart in lstResp) {
            DepartmentInfo* depart = [DepartmentInfo mj_objectWithKeyValues:dicDepart];
            [departItems addObject:depart];
        }
        _taskResult = departItems;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
