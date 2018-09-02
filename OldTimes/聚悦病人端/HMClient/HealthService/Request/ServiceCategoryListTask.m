//
//  ServiceCategoryListTask.m
//  HMClient
//
//  Created by yinqaun on 16/5/12.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceCategoryListTask.h"
#import "ServiceCategory.h"
#import "ServiceInfo.h"

@implementation ServiceCategoryListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postProductTypeServiceServiceUrl:@"getServiceCategory"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*) stepResult;
        
        NSMutableArray* cateitems = [NSMutableArray array];
        for (NSDictionary* dicCate in lstResp)
        {
            ServiceCategory* cate = [ServiceCategory mj_objectWithKeyValues:dicCate];
            [cateitems addObject:cate];
        }
        
        _taskResult = cateitems;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
    
}
@end

@implementation ServiceListTask


- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper posuserServicePoServiceUrl:@"getUserServiceByPageForOrder"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSNumber* numCount = [dicResp valueForKey:@"count"];
        NSArray* lstResp = [dicResp valueForKey:@"list"];
        NSMutableArray* serviceList = [NSMutableArray array];
        if (lstResp && [lstResp isKindOfClass:[NSArray class]])
        {
            
            for (NSDictionary* dicService in lstResp)
            {
                ServiceInfo* cate = [ServiceInfo mj_objectWithKeyValues:dicService];
                [serviceList addObject:cate];
            }

        }
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        [dicResult setValue:serviceList forKey:@"list"];
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        
        _taskResult = dicResult;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
    
}

@end
