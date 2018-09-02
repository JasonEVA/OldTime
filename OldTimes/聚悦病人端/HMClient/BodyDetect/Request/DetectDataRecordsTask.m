//
//  DetectDataRecordsTask.m
//  HMClient
//
//  Created by yinqaun on 16/5/11.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectDataRecordsTask.h"
#import "DetectRecord.h"

@implementation DetectDataRecordsMonthListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataService:@"getValueRecoderMonth"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*)stepResult;
        _taskResult = lstResp;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end

@implementation DetectDataRecordsTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataService:@"getUserTestValueRecoder"];
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
        NSMutableArray* records = [NSMutableArray array];
        
        if (list && [list isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicRecord in list)
            {
                NSString* kpi = [dicRecord valueForKey:@"kpiCode"];
                if (!kpi || 0 == kpi.length) {
                    continue;
                }
                
                NSString* recordclass = nil;
                if ([kpi isEqualToString:@"XY"]) {
                    recordclass = @"BloodPressureDetectRecord";
                }
                if ([kpi isEqualToString:@"XL"])
                {
                    recordclass = @"HeartRateDetectRecord";
                }
                if ([kpi isEqualToString:@"TZ"]) {
                    recordclass = @"BodyWeightDetectRecord";
                }
                if ([kpi isEqualToString:@"XL"]) {
                    //recordclass = @"HeartRateDetectRecord";
                }
                if ([kpi isEqualToString:@"XT"]) {
                    recordclass = @"BloodSugarDetectRecord";
                }
                if ([kpi isEqualToString:@"XZ"]) {
                    recordclass = @"BloodFatRecord";
                }
                if ([kpi isEqualToString:@"OXY"]) {
                    recordclass = @"BloodOxygenationRecord";
                }
                if ([kpi isEqualToString:@"NL"]) {
                    recordclass = @"UrineVolumeRecord";
                }
                if ([kpi isEqualToString:@"HX"]) {
                    recordclass = @"BreathingDetctRecord";
                }
                if ([kpi isEqualToString:@"TEM"]) {
                    recordclass = @"BodyTemperatureDetectRecord";
                }
                if ([kpi isEqualToString:@"FLSZ"]) {
                    recordclass = @"PEFDetectRecord";
                }
                
                if (!recordclass)
                {
                    continue;
                }
                
                DetectRecord* record = [NSClassFromString(recordclass) mj_objectWithKeyValues:dicRecord];
                [records addObject:record];
            }
        }
        if (numCount)
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        [dicResult setValue:records forKey:@"list"];
        _taskResult = dicResult;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
