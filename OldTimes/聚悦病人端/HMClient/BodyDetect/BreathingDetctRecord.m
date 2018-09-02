//
//  BreathingDetctRecord.m
//  HMClient
//
//  Created by yinqaun on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BreathingDetctRecord.h"

@implementation BreathingDetctValue

@end

@implementation BreathingDetctRecord

- (NSInteger) breathrate
{
    if (_dataDets)
    {
        return _dataDets.HX_SUB;
    }
    return 0;
}
@end

@implementation BreathingDetctResult

- (NSInteger) breathrate
{
    if (_dataDets)
    {
        return _dataDets.HX_SUB;
    }
    return 0;
}

@end