//
//  UserRecipeRecordListTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserRecipeRecordListTask.h"
#import "UserRecipeRecord.h"

@implementation UserRecipeRecordListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postRecipeServiceUrl:@"getUserRecipeRecord"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*) stepResult;
        NSMutableArray* records = [NSMutableArray array];
        for (NSDictionary* dicRecord in lstResp)
        {
            UserRecipeRecord* record = [UserRecipeRecord mj_objectWithKeyValues:dicRecord];
            [records addObject:record];
        }
        _taskResult = records;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end

@implementation UserRecipeDrugTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postRecipeServiceUrl:@"useDrug"];
    return postUrl;
}

@end
