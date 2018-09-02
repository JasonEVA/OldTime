//
//  HealthPlanSuggestionListTask.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/25.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSuggestionListTask.h"

@implementation HealthPlanSuggestionListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postcommonHealthyPlanService:@"getHealthAdvice"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSArray class]])
    {
        __block NSMutableArray* suggestionList = [NSMutableArray array];
        NSArray* respArray = (NSArray*) stepResult;
        [respArray enumerateObjectsUsingBlock:^(NSDictionary* dict, NSUInteger idx, BOOL * _Nonnull stop)
         {
             NSString* suggest = [dict valueForKey:@"title"];
             if (suggest && suggest.length > 0) {
                 [suggestionList addObject:suggest];
             }
         }];
        _taskResult = suggestionList;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end

@implementation HealthPlanLifeSuggestionListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postcommonHealthyPlanService:@"getHealthAdvice"];
    return postUrl;

}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSArray class]])
    {
        __block NSMutableArray* suggestionList = [NSMutableArray array];
        NSArray* respArray = (NSArray*) stepResult;
        [respArray enumerateObjectsUsingBlock:^(NSDictionary* dict, NSUInteger idx, BOOL * _Nonnull stop)
         {
             NSString* suggest = [dict valueForKey:@"title"];
             if (suggest && suggest.length > 0) {
                 [suggestionList addObject:suggest];
             }
         }];
        _taskResult = suggestionList;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}


@end
