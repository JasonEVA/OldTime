//
//  HealthPlanDailyListTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthPlanDailyListTask.h"
#import "PlanMessionListItem.h"
@implementation HealthPlanDailyListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthPlan2Service:@"getUserHealthyTask"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        NSNumber* numExecute = [dicResp valueForKey:@"alertExecute"];
        if (numExecute && [numExecute isKindOfClass:[NSNumber class]])
        {
            [dicResult setValue:numExecute forKey:@"alertExecute"];
        }
        
        NSNumber* numCount = [dicResp valueForKey:@"taskCount"];
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            [dicResult setValue:numCount forKey:@"taskCount"];
        }
        
        NSArray* lspResp = [dicResp valueForKey:@"data"];
        if (lspResp && [lspResp isKindOfClass:[NSArray class]])
        {
            NSMutableArray* taskItems = [NSMutableArray array];
            for (NSDictionary* dicTask in lspResp)
            {
                PlanMessionListItem* item = [PlanMessionListItem mj_objectWithKeyValues:dicTask];
                [taskItems addObject:item];
            }
            [dicResult setValue:taskItems forKey:@"list"];
        }
        
        _taskResult = dicResult;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
