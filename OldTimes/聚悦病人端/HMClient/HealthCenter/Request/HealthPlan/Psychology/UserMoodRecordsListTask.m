//
//  UserMoodRecordsListTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserMoodRecordsListTask.h"
#import "UserPsychologyDetail.h"
@implementation UserMoodRecordsListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postCommonHealthyPlanServiceUrl:@"getUserMoodRecord"];
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
        NSMutableArray* recordItems = [NSMutableArray array];
        if (lstResp && [lstResp isKindOfClass:[NSArray class]])
        {
            
            for (NSDictionary* dicService in lstResp)
            {
                UserPsychologyInfo* mood = [UserPsychologyInfo mj_objectWithKeyValues:dicService];
                [recordItems addObject:mood];
            }
            
        }
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        [dicResult setValue:recordItems forKey:@"list"];
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
