//
//  RoundsMessionsListTask.m
//  HMDoctor
//
//  Created by yinquan on 16/9/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "RoundsMessionsListTask.h"
#import "RoundsMessionModel.h"

@implementation RoundsMessionsListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postAssessmentServiceUrl:@"getWardsRoundList"];
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
            NSArray* array = [RoundsMessionModel mj_objectArrayWithKeyValuesArray:list];
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

@implementation RoundsMessionsCountTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postAssessmentServiceUrl:@"getWardsRoundCount"];
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