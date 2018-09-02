//
//  AddedValueServiceListTask.m
//  HMClient
//
//  Created by yinquan on 17/3/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "AddedValueServiceListTask.h"
#import "ServiceInfo.h"

@implementation AddedValueServiceListTask

- (NSString*) postUrl
{
//    NSString* postUrl = @"http://10.0.0.66:8080/uniqueComservice2/base.do?do=httpInterface&module=userServicePoService&method=getUserAddedValueServiceByPageForOrder";
    NSString* postUrl = [ClientHelper posuserServicePoServiceUrl:@"getUserAddedValueServiceByPageForOrder"];
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
                ServiceInfo* service = [ServiceInfo mj_objectWithKeyValues:dicService];
                [serviceList addObject:service];
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
