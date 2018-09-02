//
//  HealthPlanReviewIndicesModel.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/30.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanReviewIndicesModel.h"

@implementation HealthPlanReviewIndicesModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"id" : @"ID",
             @"name" : @"NAME"
             };
}

@end

@implementation HealthPlaneviewIndicesSection

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{ @"child" : @"CHILD",
              @"standardName" : @"STANDARDNAME",
              @"standardId" : @"STANDARDID" };
}



+ (NSDictionary *)objectClassInArray
{
    return @{@"child" : [HealthPlanReviewIndicesModel class]};
}

@end
