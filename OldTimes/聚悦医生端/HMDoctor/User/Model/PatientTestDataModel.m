//
//  PatientTestDataModel.m
//  HMDoctor
//
//  Created by kylehe on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientTestDataModel.h"
#import "NSDictionary+SafeManager.h"
static NSString *const t_testValue = @"testValue";
static NSString *const t_kpiCode = @"kpiCode";
static NSString *const t_kpiName = @"kpiName";
static NSString *const t_testTime = @"testTime";

@implementation PatientTestDataModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.testValue = [dict valueStringForKey:t_testValue];
        self.kpiCode = [dict valueStringForKey:t_kpiCode];
        self.kpoiName = [dict valueStringForKey:t_kpiName];
        self.testTime = [dict valueStringForKey:t_testTime];
    }
    return self;
}

@end
