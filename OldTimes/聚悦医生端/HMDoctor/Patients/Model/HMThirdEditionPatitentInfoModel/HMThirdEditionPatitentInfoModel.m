//
//  HMThirdEditionPatitentInfoModel.m
//  HMDoctor
//
//  Created by jasonwang on 2017/1/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMThirdEditionPatitentInfoModel.h"
#import "MJExtension.h"

@implementation HMThirdEditionPatitentInfoModel
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"assessList" : [HMThirdEditionPatitentHealthRiskModel class],
             @"userIDC" : [HMThirdEditionPatitentDiagnoseModel class]
             };
}

@end
