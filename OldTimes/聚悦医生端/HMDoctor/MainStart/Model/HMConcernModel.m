//
//  HMConcernModel.m
//  HMDoctor
//
//  Created by jasonwang on 2016/12/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMConcernModel.h"
#import "MJExtension.h"

@implementation HMConcernModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"userRemarks" : [HMConcernPatientModel class],
             @"teamRemarks":[HMConcernTeamModel class]
             };
}
@end
