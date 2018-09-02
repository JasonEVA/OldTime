//
//  LastDetectRecord.m
//  HMClient
//
//  Created by yinqaun on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "LastDetectRecord.h"

@implementation LastDetectRecord

- (NSString*) dateStr
{
    if (!self.testTime)
    {
        return nil;
    }
    
    NSDate* visitDate = [NSDate dateWithString:self.testTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateStr = [visitDate formattedDateWithFormat:@"MM月dd日"];
    
    return dateStr;
}
@end

@implementation  LastBloodPressureDetectRecord

- (NSInteger) SSY
{
    return _dataDets.SSY;
}

- (NSInteger) SZY
{
    return _dataDets.SZY;
}

- (NSInteger) XL_OF_XY
{
    return _dataDets.XL_OF_XY;
}

@end

@implementation LastHeartRateDetectRecord

- (NSInteger) heartRate
{
    if (_dataDets)
    {
        return _dataDets.XL_SUB;
    }
    return 0;
}

@end

@implementation LastBodyWeightDetectRecord

- (float) bodyBMI
{
    if (_dataDets)
    {
        return _dataDets.TZ_BMI;
    }
    return 0;
}

- (float) bodyHeight
{
    if (_dataDets)
    {
        return _dataDets.SG_OF_TZ;
    }
    return 0;
}

- (float) bodyWeight
{
    if(_dataDets)
    {
        return _dataDets.TZ_SUB;
    }
    return 0;
}

@end

@implementation LastBloodSugarDetectRecord

- (float) bloodSugar
{
    if (_dataDets)
    {
        return _dataDets.testValue;
    }
    return 0;
}

- (NSString*) detectTimeName
{
    if (_dataDets)
    {
        return _dataDets.kpiName;
    }
    return nil;
}
@end

@implementation LastBloodFatDetectRecord

-(float) TC
{
    return _dataDets.TC;
}

-(float) TG
{
    return _dataDets.TG;
}

-(float) LDL_C
{
    return _dataDets.LDL_C;
}

-(float) HDL_C
{
    return _dataDets.HDL_C;
}

-(float) TC_DIVISION_HDL_C
{
    return _dataDets.TC_DIVISION_HDL_C;
}

@end

@implementation LastBloodOxygenationDetectRecord

-(NSInteger) OXY_SUB
{
    return _dataDets.OXY_SUB;
}

-(NSInteger) PULSE_RATE
{
    return _dataDets.PULSE_RATE;
}

-(NSInteger)  PI_VAL
{
    return _dataDets.PI_VAL;
}

@end

@implementation LastUrineVolumeDetectRecord

- (NSInteger) urineVolume
{
    if (_dataDets)
    {
//       return _dataDets.testValue;
        if (_dataDets.NL_SUB_DAY > 0) {
            return _dataDets.NL_SUB_DAY;
        }
        if (_dataDets.NL_SUB_NIGHT > 0) {
            return _dataDets.NL_SUB_NIGHT;
        }
    }
    return 0;
}

- (NSString*) timeType
{
    if (_dataDets)
    {
        return _dataDets.kpiName;
    }
    return nil;
    
}

- (NSInteger) NL_SUB_DAY
{
    if (_dataDets)
    {
        return _dataDets.NL_SUB_DAY;
    }
    return 0;
}

- (NSInteger) NL_SUB_NIGHT
{
    if (_dataDets)
    {
        return _dataDets.NL_SUB_NIGHT;
    }
    return 0;
}

@end

@implementation LastBreathingDetectRecord 

- (NSInteger) breathrate
{
    if (_dataDets)
    {
        return _dataDets.HX_SUB;
    }
    return 0;
}

@end
