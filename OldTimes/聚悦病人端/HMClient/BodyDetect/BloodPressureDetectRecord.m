//
//  BloodPressureDetectRecord.m
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodPressureDetectRecord.h"

@implementation BloodPressureValue


@end

@implementation BloodPressureDetectRecord

@end

@implementation BloodPressureDataValue

@end

@implementation BloodPressureDataModel

@end

@implementation BloodPressureDetectResult

+ (NSDictionary *)objectClassInArray{
    return @{
             @"symptomList" : @"BloodPressureSymptomModel",
             @"xyTestDataVoList" : @"BloodPressureDataModel",
             };
}

@end

@implementation BloodPressureSymptomModel

@end
