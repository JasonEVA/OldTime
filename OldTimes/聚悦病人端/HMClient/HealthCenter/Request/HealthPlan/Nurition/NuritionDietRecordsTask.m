//
//  NuritionDietRecordsTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NuritionDietRecordsTask.h"
#import "NuritionDetail.h"
@implementation NuritionDietRecordsTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postCommonHealthyPlanServiceUrl:@"getUserDietRecord"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*) stepResult;
        NSMutableArray* groups = [NSMutableArray array];
        for (NSDictionary* dicGroup in lstResp)
        {
            NuritionDietGroup* group = [NuritionDietGroup mj_objectWithKeyValues:dicGroup];
            [groups addObject:group];
        }
        _taskResult = groups;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
