//
//  BodyTemperatureDetectRecord.m
//  HMDoctor
//
//  Created by yinquan on 17/4/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "BodyTemperatureDetectRecord.h"

@implementation BodyTemperatureValue

@end

@implementation BodyTemperatureDetectRecord

- (NSString*) temperature
{
    if (!self.dataDets) {
        return nil;
    }
    return self.dataDets.TEM_SUB;
}
@end

@implementation BodyTemperatureDetectResult

- (NSString*) temperature
{
    if (!self.dataDets) {
        return nil;
    }
    return self.dataDets.TEM_SUB;
}
@end
