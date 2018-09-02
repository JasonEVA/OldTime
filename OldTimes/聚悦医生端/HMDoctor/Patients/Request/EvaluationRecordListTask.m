//
//  EvaluationRecordListTask.m
//  HMClient
//
//  Created by lkl on 16/8/22.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "EvaluationRecordListTask.h"
#import "EvaluationListRecord.h"

@implementation EvaluationRecordListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postarchivesAssessmentServiceURL:@"getUserAssessmentByPage"];
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
        NSMutableArray* items = [NSMutableArray array];
        if (lstResp && [lstResp isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicEvaluation in lstResp)
            {
                EvaluationListRecord *record = [EvaluationListRecord mj_objectWithKeyValues:dicEvaluation];
                [items addObject:record];
            }
        }
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        [dicResult setValue:items forKey:@"list"];
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

@implementation EvaluationMonthsListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postarchivesAssessmentServiceURL:@"getUserAssessmentMonth"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lspResp = (NSArray*) stepResult;
        _taskResult = lspResp;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end

@implementation UserHealtySummaryTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postarchiveTemplateServiceURL:@"getUserHealtySummary"];
    return postUrl;
}

@end

