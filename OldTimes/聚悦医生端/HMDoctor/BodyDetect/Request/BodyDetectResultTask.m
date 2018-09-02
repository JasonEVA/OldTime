//
//  BodyDetectResultTask.m
//  HMClient
//
//  Created by yinqaun on 16/5/9.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyDetectResultTask.h"
#import "BodyWeightDetectRecord.h"

@implementation BodyDetectResultTask

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
    NSString* postUrl = [ClientHelper postUserTestDataService:@"getUserTestData"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSString* recordClassName = [self recordClassName];
        if (!recordClassName || 0 == recordClassName.length)
        {
            return;
        }

        id record = [NSClassFromString(recordClassName) mj_objectWithKeyValues:dicResp];
        _taskResult = record;
    }
}

- (NSString*) recordClassName
{
    return nil;
}

@end

@implementation BloodPressureDetectResultTask

- (NSString*) kpiCode
{
    return @"XY";
}

- (NSString*) recordClassName
{
    return @"BloodPressureDetectResult";
}

@end

@implementation ECGDetectResultTask

- (NSString*) kpiCode
{
    return @"XD";
}

- (NSString*) recordClassName
{
    return @"HeartRateDetectResult";
}

@end

@implementation HeartRateDetectResultTask

- (NSString*) kpiCode
{
    return @"XL";
}

- (NSString*) recordClassName
{
    return @"HeartRateDetectResult";
}

@end

@implementation BodyWeightDetectResultTask

- (NSString*) kpiCode
{
    return @"TZ";
}

- (NSString*) recordClassName
{
    return @"BodyWeightDetectResult";
}

@end

@implementation BloodSugarDetectResultTask

- (NSString*) kpiCode
{
    return @"XT";
}

- (NSString*) recordClassName
{
    return @"BloodSugarDetectResult";
}


@end

@implementation BloodFatDetectResultTask

- (NSString*) kpiCode
{
    return @"XZ";
}

- (NSString*) recordClassName
{
    return @"BloodFatResult";
}

@end

@implementation BloodOxygenationDetectResultTask

- (NSString*) kpiCode
{
    return @"OXY";
}

- (NSString*) recordClassName
{
    return @"BloodOxygenationResult";
}

@end


@implementation BreathingDetectResultTask

- (NSString*) kpiCode
{
    return @"HX";
}

- (NSString*) recordClassName
{
    return @"BreathingDetctResult";
}

@end

@implementation BodyTemperatureDetectResultTask

- (NSString*) kpiCode
{
    return @"TEM";
}

- (NSString*) recordClassName
{
    return @"BodyTemperatureDetectResult";
}

@end
