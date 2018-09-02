//
//  NuritionDetail.m
//  HMClient
//
//  Created by yinqaun on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NuritionDetail.h"

@implementation NuritionInfo

@end

@implementation NuritionDietInfo

@end


@implementation NuritionDetail

+ (NSDictionary *)objectClassInArray{
    return @{
             @"userDiets" : @"NuritionDietInfo",
             @"notes" : @"HealthNotesItem",
             };
}
@end

@implementation NuritionDietGroup

+ (NSDictionary *)objectClassInArray{
    return @{
             @"userDiets" : @"NuritionDietInfo",
             };
}

@end

@implementation NuritionDietAppendParam

@end
