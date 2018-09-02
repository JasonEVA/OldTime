//
//  UserScheduleListTask.m
//  HMDoctor
//
//  Created by lkl on 16/6/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "UserScheduleListTask.h"
#import "UserScheduleInfo.h"

@implementation UserScheduleListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserScheduleServiceUrl:@"getUserSchedules"];
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
        NSMutableArray* userScheduleArray = [NSMutableArray array];
        
        if (list && [list isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicRecord in list)
            {
                
                UserScheduleInfo* userSchedule = [UserScheduleInfo mj_objectWithKeyValues:dicRecord];
                
                //为过期
                if ([userSchedule.status isEqualToString:@"C"])
                {
                    
                }
                
                [userScheduleArray addObject:userSchedule];
            }
        }
        if (numCount)
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        [dicResult setValue:userScheduleArray forKey:@"list"];
        _taskResult = dicResult;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end


@implementation addUserScheduleTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserScheduleServiceUrl:@"addUserScheduleParams"];
    return postUrl;
}

@end

@implementation deleteUserScheduleTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserScheduleServiceUrl:@"deleteByScheduleId"];
    return postUrl;
}

@end

@implementation updateUserScheduleTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserScheduleServiceUrl:@"updateUserScheduleParams"];
    return postUrl;
}

@end

