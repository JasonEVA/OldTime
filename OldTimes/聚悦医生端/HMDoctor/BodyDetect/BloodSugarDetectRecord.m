//
//  BloodSugarDetectRecord.m
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodSugarDetectRecord.h"

@implementation BloodSugarDetectValue

@end

@implementation BloodSugarDetectRecord

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

@implementation BloodSugarDetectResult

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
