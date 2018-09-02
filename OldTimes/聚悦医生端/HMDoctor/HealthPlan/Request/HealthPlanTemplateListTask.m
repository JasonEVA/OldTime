//
//  HealthPlanTemplateListTask.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanTemplateListTask.h"

@implementation HealthPlanTemplateListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthyPlanTemplateServiceUrl:@"getHealtyPlanTemplate"];
    return postUrl;
}


- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSMutableArray* templates = [NSMutableArray array];
        NSArray* dictionarys = (NSArray*) stepResult;
        [dictionarys enumerateObjectsUsingBlock:^(NSDictionary* dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
            HealthPlanDepartmentTemplateModel* templateModel = [HealthPlanDepartmentTemplateModel mj_objectWithKeyValues:dictionary];
            [templates addObject:templateModel];
        }];
    
        _taskResult = templates;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
