//
//  HealthPlanMessionListTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HealthPlanMessionListTask.h"
#import "HealthPlanMessionInfo.h"

@implementation HealthPlanMessionListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthPlan2ServiceServiceUrl:@"getUserHealthPlan"];
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
        NSMutableArray* messions = [NSMutableArray array];
        
        if (list && [list isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicMession in list)
            {
                
                HealthPlanMessionInfo* mession = [HealthPlanMessionInfo mj_objectWithKeyValues:dicMession];
                
                [messions addObject:mession];
            }
        }
        if (numCount)
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        [dicResult setValue:messions forKey:@"list"];
        _taskResult = dicResult;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end

@implementation HealthPlanListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthyPlanUserListServiceServiceUrl:@"getUserHealthPlan"];
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
        NSMutableArray* messions = [NSMutableArray array];
        
        if (list && [list isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicMession in list)
            {
                
                HealthPlanMessionInfo* mession = [HealthPlanMessionInfo mj_objectWithKeyValues:dicMession];
                
                [messions addObject:mession];
            }
        }
        if (numCount)
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        [dicResult setValue:messions forKey:@"list"];
        _taskResult = dicResult;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end

@implementation HealthPlanListCountTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthyPlanUserListServiceServiceUrl:@"getUserHealthyPlanStatusCount"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSArray class]])
    {
        _taskResult = stepResult;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
