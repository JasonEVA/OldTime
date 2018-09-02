//
//  UrineVolumeRecord.m
//  HMClient
//
//  Created by yinqaun on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UrineVolumeRecord.h"

@implementation UrineVolumeValue

@end

@implementation UrineVolumeRecord

- (NSInteger) urineVolume
{
    if (_dataDets)
    {
        return _dataDets.testValue;
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
@end

@implementation UrineVolumeResult

- (NSInteger) urineVolume
{
    if (_dataDets)
    {
        return _dataDets.testValue;
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

@end
