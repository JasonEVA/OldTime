//
//  AssessmentMessionListTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AssessmentMessionListTask.h"
#import "AssessmentMessionModel.h"

@implementation AssessmentMessionListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postAssessmentServiceUrl:@"doctorAssessTask"];
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
            NSArray* array = [AssessmentMessionModel mj_objectArrayWithKeyValuesArray:list];
            messions = [NSMutableArray arrayWithArray:array];
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


@implementation AssessmentMessionCountTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postAssessmentServiceUrl:@"doctorAssessTaskCount"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSNumber class]])
    {
        _taskResult = (NSNumber*) stepResult;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end

@implementation AssessmentCategoryTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postassessmentServiceURL:@"getAssessmentCategory"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* dicResp = (NSArray*) stepResult;
        NSMutableArray* items = [NSMutableArray array];
        NSMutableArray* details = [NSMutableArray array];
        if (dicResp && [dicResp isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicAssessmentCategory in dicResp)
            {
                AssessmentCategoryModel *category = [AssessmentCategoryModel mj_objectWithKeyValues:dicAssessmentCategory];
                [items addObject:category];
                
                /*for (NSDictionary* dicAssessmentList in category.details)
                 {
                 AssessmentCategoryModel1 *assessmentList = [AssessmentCategoryModel1 mj_objectWithKeyValues:dicAssessmentList];
                 [details addObject:assessmentList];
                 }*/
            }
        }
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        [dicResult setValue:items forKey:@"assessmentCategory"];
        [dicResult setValue:details forKey:@"details"];
        
        _taskResult = items;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end



@implementation AssessmentTemplateListTask : SingleHttpRequestTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postassessmentServiceURL:@"getAssessmentTemplate"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* dicResp = (NSArray*) stepResult;
        NSMutableArray* items = [NSMutableArray array];
        if (dicResp && [dicResp isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicAssessmentCategory in dicResp)
            {
                AssessmentTemplateModel *category = [AssessmentTemplateModel mj_objectWithKeyValues:dicAssessmentCategory];
                [items addObject:category];
            }
        }
        
        _taskResult = items;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end

