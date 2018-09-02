//
//  UserSportsDetail.m
//  HMClient
//
//  Created by yinqaun on 16/6/15.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserSportsDetail.h"
//#import "HealthEducationItem.h"

@implementation SportsEachTime


@end

@implementation RecommandSportsType


@end

@implementation UserSportsDetail

+ (NSDictionary *)objectClassInArray{
    return @{
             @"userSportsEachTimes" : @"SportsEachTime",
             @"sportType" : @"RecommandSportsType",
             @"notes" : @"HealthNotesItem",
             };
}
@end
