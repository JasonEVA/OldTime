//
//  HealthPlanFillFormTemplateList.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/25.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanFillFormTemplateListTask.h"

@implementation HealthPlanFillFormTemplateListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthyPlanTemplateServiceUrl:@"getStandardDepMoudleByTypeCode"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSMutableArray* templates = [NSMutableArray array];
        //HealthPlanFillFormTemplateSection
        NSArray* dictionarys = (NSArray*) stepResult;
        [dictionarys enumerateObjectsUsingBlock:^(NSDictionary* dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
            HealthPlanFillFormTemplateSection* templateModel = [HealthPlanFillFormTemplateSection mj_objectWithKeyValues:dictionary];
            [templates addObject:templateModel];
        }];
        _taskResult = templates;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end

@implementation HealthPlanReviewIndicesListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthyPlanTemplateServiceUrl:@"getReviewIndicesItems"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSMutableArray* templates = [NSMutableArray array];
        //HealthPlanFillFormTemplateSection
        NSArray* dictionarys = (NSArray*) stepResult;
        [dictionarys enumerateObjectsUsingBlock:^(NSDictionary* dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
            HealthPlaneviewIndicesSection* templateModel = [HealthPlaneviewIndicesSection mj_objectWithKeyValues:dictionary];
            [templates addObject:templateModel];
        }];
        _taskResult = templates;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
