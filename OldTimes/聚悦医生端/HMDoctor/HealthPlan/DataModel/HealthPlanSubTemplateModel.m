//
//  HealthPlanSubTemplateModel.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/30.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSubTemplateModel.h"

@implementation HealthPlanSubTemplateModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"sportsType" : [HealthSportTypeModel class]};
}

@end
