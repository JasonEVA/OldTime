//
//  HealthEducationSearchListTask.m
//  HMDoctor
//
//  Created by yinquan on 17/1/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthEducationSearchListTask.h"
#import "HealthEducationItem.h"

@implementation HealthEducationSearchListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postMcClassServiceUrl:@"findClassListByKeyword"];
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
