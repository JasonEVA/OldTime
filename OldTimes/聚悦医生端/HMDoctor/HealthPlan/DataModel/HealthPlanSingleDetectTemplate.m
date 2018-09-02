//
//  HealthPlanSingleDetectTemplate.m
//  HMDoctor
//
//  Created by yinquan on 2017/9/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSingleDetectTemplate.h"

@implementation HealthPlanSingleDetectTemplateModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"id" : @"ID",
             @"name" : @"NAME"
             };
}

@end

@implementation HealthPlanSingleDetectSectionModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{ @"child" : @"CHILD",
              @"standardName" : @"STANDARDNAME",
              @"standardId" : @"STANDARDID" };
}



+ (NSDictionary *)objectClassInArray
{
    return @{@"child" : [HealthPlanSingleDetectTemplateModel class]};
}

@end
