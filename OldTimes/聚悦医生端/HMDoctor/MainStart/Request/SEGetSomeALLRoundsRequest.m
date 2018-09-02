//
//  SEGetSomeALLRoundsRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2017/9/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SEGetSomeALLRoundsRequest.h"
#import "RoundsMessionModel.h"

@implementation SEGetSomeALLRoundsRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postAssessmentServiceUrl:@"findUserWardsRoundList"];
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
