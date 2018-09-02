//
//  HealthPlanTemplateModel.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanTemplateModel.h"

@implementation HealthPlanTemplateModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{ @"id" : @"ID",
              @"name" : @"NAME" };
}


@end

@implementation HealthPlanDepartmentTemplateModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{ @"standardName" : @"STANDARDNAME",
              @"standardId" : @"STANDARDID",
              @"child": @"CHILD"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"child" : [HealthPlanTemplateModel class]};
}

@end
