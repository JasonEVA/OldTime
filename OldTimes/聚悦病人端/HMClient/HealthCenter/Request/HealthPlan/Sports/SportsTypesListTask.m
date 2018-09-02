//
//  SportsTypesListTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/15.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SportsTypesListTask.h"
#import "UserSportsDetail.h"

@implementation SportsTypesListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postCommonHealthyPlanServiceUrl:@"getSportsType"];
    return postUrl;
}


- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lspResp = (NSArray*) stepResult;
        NSMutableArray* typeItems = [NSMutableArray array];
        for (NSDictionary* dicType in lspResp)
        {
            RecommandSportsType* sportType = [RecommandSportsType mj_objectWithKeyValues:dicType];
            [typeItems addObject:sportType];
        }
        _taskResult = typeItems;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end

@implementation RecordUserSportsTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postCommonHealthyPlanServiceUrl:@"addUserSportsRecord"];
    return postUrl;
}

@end
