//
//  HealthReportListTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HealthReportListTask.h"
#import "HealthReportInfo.h"

@implementation HealthReportListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserHealtReportServiceUrl:@"getUserHealthyReportList"];
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
        NSMutableArray* reports = [NSMutableArray array];
        
        if (list && [list isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicReport in list)
            {
                
                HealthReportInfo* report = [HealthReportInfo mj_objectWithKeyValues:dicReport];
                
                [reports addObject:report];
            }
        }
        if (numCount)
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        [dicResult setValue:reports forKey:@"list"];
        _taskResult = dicResult;
        return;

    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
