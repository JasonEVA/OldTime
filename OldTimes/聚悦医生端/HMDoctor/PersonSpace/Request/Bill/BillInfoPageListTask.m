//
//  BillInfoPageListTask.m
//  HMDoctor
//
//  Created by lkl on 16/6/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "BillInfoPageListTask.h"
#import "BillInfo.h"

@implementation BillInfoPageListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrderServiceUrl:@"getMyBillByPage"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSNumber* numCount = [dicResp valueForKey:@"count"];
        NSArray* list = [dicResp valueForKey:@"list"];
        NSMutableArray* billList = [NSMutableArray array];
        
        if (list && [list isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicBill in list)
            {
                
                BillInfo* bill = [BillInfo mj_objectWithKeyValues:dicBill];
                
                [billList addObject:bill];
            }
        }
        if (numCount)
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        [dicResult setValue:billList forKey:@"list"];
        _taskResult = dicResult;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end

@implementation BillSumPriceTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrderServiceUrl:@"getMyBillSumPrice"];
    return postUrl;
}

@end

@implementation BillSubmitTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrderServiceUrl:@"divideSubmit"];
    return postUrl;
}

@end
