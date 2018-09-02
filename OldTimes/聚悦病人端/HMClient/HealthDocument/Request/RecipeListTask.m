//
//  RecipeListTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "RecipeListTask.h"
#import "RecipeRecord.h"

@implementation RecipeMonthsListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postRecipeServiceUrl:@"getUserRecipeMonths"];
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

@implementation RecipeRecordsListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postRecipeServiceUrl:@"getUserRecipeByMonth"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lspResp = (NSArray*) stepResult;
        NSMutableArray* records = [NSMutableArray array];
        for (NSDictionary* dicRecord in lspResp)
        {
            RecipeRecord* record = [RecipeRecord mj_objectWithKeyValues:dicRecord];
            [records addObject:record];
        }
        _taskResult = records;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
