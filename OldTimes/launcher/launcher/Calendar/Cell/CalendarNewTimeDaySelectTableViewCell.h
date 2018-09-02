//
//  CalendarNewTimeDaySelectTableViewCell.h
//  launcher
//
//  Created by William Zhang on 15/8/4.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  📅候补时间选择日期选择器 （不带日期）

#import <UIKit/UIKit.h>
#import "CalendarTimeSelectDefine.h"

@interface CalendarNewTimeDaySelectTableViewCell : UITableViewCell

+ (NSString *)identifier;
+ (CGFloat)height;

- (void)setTitle:(NSString *)title showTrash:(BOOL)showTrash;
- (void)showAllDaySwitch;

- (void)setDeleteBlock:(CalendarNewTimeDeleteBlock)block didChange:(CalendarNewTimeDidChangeBlock)didChangeBlock;
- (void)switchDay:(void(^)())switchBlock;
- (void)setStartDate:(NSDate *)date endData:(NSDate *)endDate;

@end
