//
//  StaffMessionStatisticsTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "StaffMessionStatisticsTask.h"
#import "StaffMessionStatistics.h"

@implementation StaffMessionStatisticsTask

- (NSString*) postUrl
{
//    NSString* postUrl = [ClientHelper postWorkTaskServiceUrl:@"getStaffWorkTask"];
    NSString* postUrl = [ClientHelper postWorkTaskServiceUrl:@"homePageSummary"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lspResp = (NSArray*) stepResult;
        NSMutableArray* statisticsList = [NSMutableArray array];
        for (NSDictionary* dicStatistics in lspResp) {
            StaffMessionStatistics* statistics = [StaffMessionStatistics mj_objectWithKeyValues:dicStatistics];
            [statisticsList addObject:statistics];
        }
        
        _taskResult = statisticsList;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
