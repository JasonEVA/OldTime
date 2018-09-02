//
//  HeartRateDetectRecord.m
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HeartRateDetectRecord.h"

@implementation HeartRateDetectValue
//+ (NSDictionary *)objectClassInArray{
//    return @{
//             @"BITMAP" : @"NSString"
//            
//             };
//}
@end

@implementation HeartRateDetectRecord

- (NSInteger) heartRate
{
    if (_dataDets)
    {
        return _dataDets.XL_SUB;
    }
    return 0;
}

- (NSString*) kpi
{
    if (_dataDets)
    {
        return _dataDets.kpi;
    }
    return nil;
}

@end


@implementation HeartRateDetectResult

- (NSInteger) heartRate
{
    if (_dataDets)
    {
        return _dataDets.XL_OF_XD;
    }
    return 0;
}


@end