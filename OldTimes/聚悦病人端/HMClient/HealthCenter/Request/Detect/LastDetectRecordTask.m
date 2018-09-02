//
//  LastDetectRecordTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "LastDetectRecordTask.h"
#import "LastDetectRecord.h"

@implementation LastDetectRecordTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataService:@"getLastTestData"];
    return postUrl;
}

- (NSString*)kpiCode
{
    NSDictionary* dicParam = (NSDictionary*)taskParam;
    if (dicParam && [dicParam isKindOfClass:[NSDictionary class]])
    {
        NSString* kpiCode = [dicParam valueForKey:@"kpiCode"];
        if (kpiCode && [kpiCode isKindOfClass:[NSString class]] && 0 < kpiCode.length)
        {
            return kpiCode;
        }
    }
    return nil;
}

- (NSString*) recordClassName
{
    NSString* kpiCode = [self kpiCode];
    if (!kpiCode || ![kpiCode isKindOfClass:[NSString class]] || 0 == kpiCode.length)
    {
        return @"LastDetectRecord";
    }
    NSString* classname = @"LastDetectRecord";
    
    if ([kpiCode isEqualToString:@"XY"])
    {
        classname = @"LastBloodPressureDetectRecord";
    }
    if ([kpiCode isEqualToString:@"XL"])
    {
        classname = @"LastHeartRateDetectRecord";
    }
    if ([kpiCode isEqualToString:@"TZ"])
    {
        classname = @"LastBodyWeightDetectRecord";
    }
    if ([kpiCode isEqualToString:@"XT"])
    {
        classname = @"LastBloodSugarDetectRecord";
    }
    if ([kpiCode isEqualToString:@"XZ"])
    {
        classname = @"LastBloodFatDetectRecord";
    }
    if ([kpiCode isEqualToString:@"OXY"])
    {
        classname = @"LastBloodOxygenationDetectRecord";
    }
    if ([kpiCode isEqualToString:@"NL"])
    {
        classname = @"LastUrineVolumeDetectRecord";
    }
    if ([kpiCode isEqualToString:@"HX"])
    {
        classname = @"LastBreathingDetectRecord";
    }
    return classname;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSString* recordClassName = [self recordClassName];
        LastDetectRecord* record = [NSClassFromString(recordClassName) mj_objectWithKeyValues:dicResp];
        _taskResult = record;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
