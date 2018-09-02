//
//  BodyDetectRecordsTask.m
//  HMClient
//
//  Created by yinqaun on 16/5/9.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodPressureDetectRecord.h"
#import "BodyWeightDetectRecord.h"

#import "BodyDetectRecordsTask.h"


@implementation BodyDetectRecordsTask

- (id) initWithTaskId:(NSString*) taskId
{
    self = [super initWithTaskId:taskId];
    if (self)
    {
        if (taskParam && [taskParam isKindOfClass:[NSDictionary class]])
        {
            NSString* kpiCode = [self kpiCode];
            NSMutableDictionary* dicParam = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)taskParam];
            if (kpiCode && 0 < kpiCode.length)
            {
                [dicParam setValue:kpiCode forKey:@"kpiCode"];
            }
            
            
            taskParam = dicParam;
        }
        
    }
    return self;
}

- (NSString*) kpiCode
{
    return nil;
}

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataService:@"getUserTestDataList"];
    return postUrl;
}

- (NSString*) recordClassName
{
    return nil;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSNumber* numCount = [dicResp valueForKey:@"count"];
        NSArray* lstDict = [dicResp valueForKey:@"list"];
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        
        if (lstDict && [lstDict isKindOfClass:[NSArray class]])
        {
            NSMutableArray* records = [NSMutableArray array];
            NSString* recordClassName = [self recordClassName];
            if (!recordClassName || 0 == recordClassName.length)
            {
                return;
            }
            for (NSDictionary* dicRecord in lstDict)
            {
                id record = [NSClassFromString(recordClassName) mj_objectWithKeyValues:dicRecord];
                [records addObject:record];
            }
            [dicResult setValue:records forKey:@"list"];
        }
        
        _taskResult = dicResult;
    }
}


@end

@implementation BloodPressureRecordsTask

- (NSString*) kpiCode
{
    return @"XY";
}

- (NSString*) recordClassName
{
    return @"BloodPressureDetectRecord";
}
@end

@implementation HeartRateRecordsTask

- (NSString*) kpiCode
{
    return @"XL";
}

- (NSString*) recordClassName
{
    return @"HeartRateDetectRecord";
}
@end

@implementation BodyWeightRecordsTask

- (NSString*) kpiCode
{
    return @"TZ";
}

- (NSString*) recordClassName
{
    return @"BodyWeightDetectRecord";
}

@end

@implementation BloodSugarRecordsTask

- (NSString*) kpiCode
{
    return @"XT";
}

- (NSString*) recordClassName
{
    return @"BloodSugarDetectRecord";
}

@end

@implementation BloodFatRecordsTask

- (NSString*) kpiCode
{
    return @"XZ";
}

- (NSString*) recordClassName
{
    return @"BloodFatRecord";
}

@end


@implementation BloodOxygenationRecordsTask

- (NSString*) kpiCode
{
    return @"OXY";
}

- (NSString*) recordClassName
{
    return @"BloodOxygenationRecord";
}

@end

@implementation UrineVolumeRecordsTask

- (NSString*) kpiCode
{
    return @"NL";
}

- (NSString*) recordClassName
{
    return @"UrineVolumeRecord";
}

@end

@implementation BreathingRecordsTask

- (NSString*) kpiCode
{
    return @"HX";
}

- (NSString*) recordClassName
{
    return @"BreathingDetctRecord";
}

@end

@implementation BodyTemperatureRecordsTask

- (NSString*) kpiCode
{
    return @"TEM";
}

- (NSString*) recordClassName
{
    return @"BodyTemperatureDetectRecord";
}

@end

@implementation PEFRecordsTask

- (NSString*) kpiCode
{
    return @"FLSZ";
}

- (NSString*) recordClassName
{
    return @"PEFDetectRecord";
}

@end

