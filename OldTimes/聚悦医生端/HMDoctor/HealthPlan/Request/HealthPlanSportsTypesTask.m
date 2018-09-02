//
//  HealthPlanSportsTypesTask.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/30.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSportsTypesTask.h"

@implementation HealthPlanSportsTypesTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postcommonHealthyPlanService:@"getSportsType"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSArray class]])
    {
        __block NSMutableArray* types = [NSMutableArray array];
        NSArray* respArray = (NSArray*) stepResult;
        
        [respArray enumerateObjectsUsingBlock:^(NSDictionary* dict, NSUInteger idx, BOOL * _Nonnull stop) {
            HealthSportTypeModel* typeModel = [HealthSportTypeModel mj_objectWithKeyValues:dict];
            [types addObject:typeModel];
        }];
        
        _taskResult = types;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
