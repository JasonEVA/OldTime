//
//  HealthEducationListTask.m
//  HMClient
//
//  Created by lkl on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthEducationListTask.h"
#import "HealthEducationItem.h"
#import "HealthyEducationColumeModel.h"

@implementation HealthEducationColumeTask

- (void) makeCachePath
{
    self.cachePath = [HealthEducationPathHelper healthEducationColumeCachePath];
}

- (void) makeCacheTime
{
    self.cacheTime = 4 * 60 * 60;
}

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postMcClassServiceUrl:@"findClassTypeList"];
    return postUrl;
}

- (void) makeCacheTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]]) {
        NSArray* lstResp = (NSArray*) stepResult;
        
        _taskResult = lstResp;
        _taskError = StepError_None;
        _taskErrorMessage = currentStep.stepErrorMessage;
        return;
    }
    
    _taskError = StepError_ReadDataError;
    _taskErrorMessage = @"缓存数据读取失败。";
}

- (void) makeHttpRquestTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if (stepResult && [stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*)stepResult;
        NSMutableArray* columes = [NSMutableArray array];
        
        [lstResp enumerateObjectsUsingBlock:^(NSDictionary* dicCol, NSUInteger idx, BOOL * _Nonnull stop) {
            HealthyEducationColumeModel* model = [HealthyEducationColumeModel mj_objectWithKeyValues:dicCol];
            [columes addObject:model];
        }];
        
        _taskError = StepError_None;
        _taskResult = columes;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}


@end

@implementation HealthEducationListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postMcClassServiceUrl:@"findClassListByTypeId"];
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
        NSMutableArray* items = [NSMutableArray array];
        
        if (list && [list isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicItem in list)
            {
                
                HealthEducationItem* item = [HealthEducationItem mj_objectWithKeyValues:dicItem];
                
                [items addObject:item];
            }
        }
        if (numCount)
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        [dicResult setValue:items forKey:@"list"];
        _taskResult = dicResult;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end

@implementation HealthEducationListWithPlanTypeTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postMcClassServiceUrl:@"findClassListByPlanType"];
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
        NSMutableArray* items = [NSMutableArray array];
        
        if (list && [list isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicItem in list)
            {
                
                HealthEducationItem* item = [HealthEducationItem mj_objectWithKeyValues:dicItem];
                
                [items addObject:item];
            }
        }
        if (numCount)
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        [dicResult setValue:items forKey:@"list"];
        _taskResult = dicResult;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
