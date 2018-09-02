//
//  StaffServiceListTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "StaffServiceListTask.h"
#import "ServiceInfo.h"
#import "ServiceRecordInfo.h"

@implementation StaffServiceListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServicePoServiceUrl:@"getStaffProviderService"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        
        NSArray* lstResp = (NSArray*) stepResult;
        NSMutableArray* serviceList = [NSMutableArray array];
        if (lstResp && [lstResp isKindOfClass:[NSArray class]])
        {
            
            for (NSDictionary* dicService in lstResp)
            {
                ServiceInfo* cate = [ServiceInfo mj_objectWithKeyValues:dicService];
                [serviceList addObject:cate];
            }
            
        }
        
        _taskResult = serviceList;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
    
}

@end

@implementation StaffServiceHistoryListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServicePoServiceUrl:@"getOrderServiceRecord"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSNumber* numCount = [dicResp valueForKey:@"count"];
        NSArray* list = [dicResp valueForKey:@"list"];
        NSMutableArray* records = [NSMutableArray array];
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        if (list && [list isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicRecord in list)
            {
                
                ServiceRecordInfo* record = [ServiceRecordInfo mj_objectWithKeyValues:dicRecord];
                [records addObject:record];
            }
        }
        if (numCount)
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        [dicResult setValue:records forKey:@"list"];
        _taskResult = dicResult;

        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
    
}

@end
