//
//  HMHomeModel.m
//  HMClient
//
//  Created by JasonWang on 2017/5/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMHomeModel.h"

@implementation HMHomeModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"systemUserCares":@"UserCareInfo",
             @"doctorCares":@"DoctorGreetingInfo",
             @"healthyTask":@"PlanMessionListItem",
             @"userTestTarget":@"MainStartHealthTargetModel"
             };
}
@end
