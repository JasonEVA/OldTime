//
//  PointRedemptionCalendarView.h
//  JYClientDemo
//
//  Created by yinquan on 2017/7/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointRedemptionCalendarDateCell : UIView


@end


@interface PointRedemptionCalendarView : UIView

- (void) setMonth:(NSString*) monthString;  //yyyy-MM

- (void) setMonthlyPointRecordModels:(NSArray*) models;
@end
