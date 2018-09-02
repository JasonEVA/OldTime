//
//  OrderServiceListTask.m
//  HMClient
//
//  Created by yinquan on 16/11/14.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OrderServiceListTask.h"
#import "OrderedServiceModel.h"


@implementation OrderServiceListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper posuserServicePoServiceUrl:@"getMyUserServiceV23"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]]) {
        NSArray* lstResp = (NSArray*) stepResult;
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        NSMutableArray* appreciationServiceList = [NSMutableArray array];
        OrderedServiceModel* packageService = nil;
        for (NSDictionary* dicService in lstResp) {
            
            OrderedServiceModel* model = [OrderedServiceModel mj_objectWithKeyValues:dicService];
            if (model.classify != 5)
            {
                //套餐服务
                if (packageService) {
                    continue ;
                }
                packageService = model;
                [dicResult setValue:packageService forKey:@"packageServie"];
            }
            else
            {
                //增值服务
                [appreciationServiceList addObject:model];
            }
            
        }
        if (appreciationServiceList.count > 0) {
            [dicResult setValue:appreciationServiceList forKey:@"appreciationService"];
        }
        _taskResult = dicResult;
        _taskError = StepError_None;
        _taskErrorMessage = currentStep.stepErrorMessage;
        return;
    }
    
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器接口调用失败。";
}

@end

@implementation OrderServiceHistoryListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper posuserServicePoServiceUrl:@"getMyUserServiceV23"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary* resultDict = [NSMutableDictionary dictionary];
        NSDictionary* respDict = (NSDictionary*) stepResult;
        NSNumber* numCount = [respDict valueForKey:@"count"];
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            [resultDict setValue:numCount forKey:@"count"];
        }
        NSArray* lstResp = [respDict valueForKey:@"list"];
        
        NSMutableArray* serviceList = [NSMutableArray array];
        for (NSDictionary* dicService in lstResp) {
            
            OrderedServiceModel* model = [OrderedServiceModel mj_objectWithKeyValues:dicService];
            [serviceList addObject:model];
        }
        
        [resultDict setValue:serviceList forKey:@"list"];
        _taskResult = resultDict;
        _taskError = StepError_None;
        _taskErrorMessage = currentStep.stepErrorMessage;
        return;

    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器接口调用失败。";
}
@end


