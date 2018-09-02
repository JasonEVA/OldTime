//
//  OrderListTask.m
//  HMClient
//
//  Created by yinqaun on 16/5/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OrderListTask.h"
#import "OrderInfo.h"
#import "UserServiceInfo.h"
#import "ServiceInfo.h"

@implementation OrderListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrderServiceUrl:@"orderList"];
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
        NSMutableArray* orderItems = [NSMutableArray array];
        if (lstResp && [lstResp isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicOrder in lstResp)
            {
                OrderInfo* order = [OrderInfo mj_objectWithKeyValues:dicOrder];
                [orderItems addObject:order];
            }
        }
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        [dicResult setValue:orderItems forKey:@"list"];
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

@implementation OrderDetailTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrderServiceUrl:@"getMcOrder"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSDictionary* dicOrder = [dicResp valueForKey:@"order"];
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        if (dicOrder && [dicOrder isKindOfClass:[NSDictionary class]])
        {
            OrderInfo* order = [OrderInfo mj_objectWithKeyValues:dicOrder];
            [dicResult setValue:order forKey:@"order"];
            
            if (order.orderTypeCode)
            {
                if ([order.orderTypeCode isEqualToString:@"SERVICE"])
                {
                    NSDictionary* dicService = [dicResp valueForKey:@"userService"];
                    UserServiceInfo* service = [UserServiceInfo mj_objectWithKeyValues:dicService];
                    [dicResult setValue:service forKey:@"product"];
                    
                    
                }
            }
            
            _taskResult = dicResult;
            return;
        }
    }
}

@end

@implementation OrderPayWayListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrderServiceUrl:@"getPayWayList"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSMutableArray* payways = [NSMutableArray array];
        NSArray* lstResp = (NSArray*) stepResult;
        for (NSDictionary* dicWay in lstResp)
        {
            ServicePayWay* payway = [ServicePayWay mj_objectWithKeyValues:dicWay];
            [payways addObject:payway];
        }
        _taskResult = payways;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
