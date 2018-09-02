//
//  StaffTeamDoctorModel.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "StaffTeamDoctorModel.h"

@implementation StaffTeamDoctorModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"staffName" : @"STAFF_NAME",
             @"staffId" : @"STAFF_ID",
             @"userId" : @"USER_ID"
             };
}
@end

