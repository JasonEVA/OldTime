//
//  PointRedemptionWeeklyControl.h
//  JYClientDemo
//
//  Created by yinquan on 2017/7/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointRedemptionWeeklyControl : UIControl

- (void) setContinuityDays:(NSInteger) continuityDays   //连续签到天数
             lastPointDate:(NSString*) lastPointDate;   //最后一次签到次数
@end
