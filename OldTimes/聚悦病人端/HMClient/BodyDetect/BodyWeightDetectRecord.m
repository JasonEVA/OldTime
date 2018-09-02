//
//  BodyWeightDetectRecord.m
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyWeightDetectRecord.h"

@implementation BodyWeightDetectValue

@end

@implementation BodyWeightDetectRecord

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

@end

@implementation BodyWeightDetectResult

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
@end