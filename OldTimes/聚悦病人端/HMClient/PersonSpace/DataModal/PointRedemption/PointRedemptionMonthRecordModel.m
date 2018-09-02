//
//  PointRedemptionMonthRecordModel.m
//  HMClient
//
//  Created by yinquan on 2017/7/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PointRedemptionMonthRecordModel.h"

@implementation PointRedemptionMonthRecordModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"isSigned" : @"signed",
             };
}
@end
