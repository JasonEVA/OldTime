//
//  HealthPlanFillFormTemplateModel.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/25.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanFillFormTemplateModel.h"

@implementation HealthPlanFillFormTemplateModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
                @"surveyMoudleId" : @"ID",
                @"surveyMoudleName" : @"NAME"
             };
}
@end

@implementation HealthPlanFillFormTemplateSection

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{ @"child" : @"CHILD",
              @"standardName" : @"STANDARDNAME",
              @"standardId" : @"STANDARDID" };
}



+ (NSDictionary *)objectClassInArray
{
    return @{@"child" : [HealthPlanFillFormTemplateModel class]};
}

@end
