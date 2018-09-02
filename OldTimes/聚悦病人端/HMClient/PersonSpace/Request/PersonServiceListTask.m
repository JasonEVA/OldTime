//
//  PersonServiceListTask.m
//  HMClient
//
//  Created by yinqaun on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonServiceListTask.h"
#import "UserServiceInfo.h"
#import "InitializationHelper.h"

@implementation PersonServiceListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper posuserServicePoServiceUrl:@"getMyUserService"];
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
        NSMutableArray* serviceItems = [NSMutableArray array];
        if (lstResp && [lstResp isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicOrder in lstResp)
            {
                UserServiceInfo* service = [UserServiceInfo mj_objectWithKeyValues:dicOrder];
                [serviceItems addObject:service];
            }
        }
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        [dicResult setValue:serviceItems forKey:@"list"];
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        
        
        _taskResult = dicResult;
        
        if (serviceItems && 0 < serviceItems.count)
        {
            if (!taskParam || ![taskParam isKindOfClass:[NSDictionary class]])
            {
                return;
            }
            NSDictionary* dicParam = (NSDictionary*) taskParam;
            NSArray* statusItems = [dicParam valueForKey:@"status"];
            if (!statusItems || 1 != statusItems.count) {
                return;
            }
            
            NSString* status = statusItems[0];
            if (![status isEqualToString:@"2"])
            {
                return;
            }
            
            //InitializationHelper* helper = [InitializationHelper defaultHelper];
            //[helper setUserService:[serviceItems firstObject]];
        }
        
        

        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}


@end

@implementation PersonServiceDetailTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper posuserServicePoServiceUrl:@"getUserServiceDets"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*) stepResult;
        NSMutableArray* detItems = [NSMutableArray array];
        for (NSDictionary* dicDet in lstResp)
        {
            UserServiceDetInfo* detInfo = [UserServiceDetInfo mj_objectWithKeyValues:dicDet];
            [detItems addObject:detInfo];
        }
        
        _taskResult = detItems;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end



//V2.3
@implementation PersonServiceV23ListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper posuserServicePoServiceUrl:@"getMyUserServiceV23"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*) stepResult;

        NSMutableArray* serviceItems = [NSMutableArray array];
        if (lstResp && [lstResp isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicOrder in lstResp)
            {
                UserServiceInfo* service = [UserServiceInfo mj_objectWithKeyValues:dicOrder];
                [serviceItems addObject:service];
            }
        }
        
        _taskResult = serviceItems;
        
        if (serviceItems && 0 < serviceItems.count)
        {
            if (!taskParam || ![taskParam isKindOfClass:[NSDictionary class]])
            {
                return;
            }
            NSDictionary* dicParam = (NSDictionary*) taskParam;
            NSArray* statusItems = [dicParam valueForKey:@"status"];
            if (!statusItems || 1 != statusItems.count) {
                return;
            }
            
            NSString* status = statusItems[0];
            if (![status isEqualToString:@"2"])
            {
                return;
            }
            
            //InitializationHelper* helper = [InitializationHelper defaultHelper];
            //[helper setUserService:[serviceItems firstObject]];
        }
        
        
        
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end


@implementation PersonServiceSummaryTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper posuserServicePoServiceUrl:@"getMyUserServiceSummary"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSString* endTime = [dicResp objectForKey:@"endTime"];
        NSString* productName = [dicResp objectForKey:@"productName"];
        NSArray* serviceDets = [dicResp objectForKey:@"serviceDets"];
        NSMutableArray* detItems = [NSMutableArray array];
        for (NSDictionary* dicDet in serviceDets)
        {
            UserServiceDetInfo* detInfo = [UserServiceDetInfo mj_objectWithKeyValues:dicDet];
            [detItems addObject:detInfo];
        }
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        [dicResult setValue:detItems forKey:@"serviceDets"];
        if (endTime && [endTime isKindOfClass:[NSString class]])
        {
            [dicResult setValue:endTime forKey:@"endTime"];
        }
        
        if (productName && [productName isKindOfClass:[NSString class]])
        {
            [dicResult setValue:productName forKey:@"productName"];
        }
        
        _taskResult = dicResult;
        return;
    }
//    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}


@end
