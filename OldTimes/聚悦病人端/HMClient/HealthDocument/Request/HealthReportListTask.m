//
//  HealthReportListTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthReportListTask.h"
#import "HealthReport.h"

@implementation HealthReportListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserHealthyReportServiceUrl:@"getUserHasBeenSentHealthyReportList"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        
        NSNumber* numCount = [dicResp valueForKey:@"count"];
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        
        NSMutableArray* reports = [NSMutableArray array];
        NSArray* lspReports = [dicResp valueForKey:@"list"];
        for (NSDictionary* dicReport in lspReports)
        {
            HealthReport* report = [HealthReport mj_objectWithKeyValues:dicReport];
            [reports addObject:report];
        }
        
        [dicResult setValue:reports forKey:@"list"];
        _taskResult = dicResult;
        return ;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end

@implementation HealthReportReadedMarkTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserHealthyReportServiceUrl:@"markHealthyReportListReaded"];
    return postUrl;
}

@end
