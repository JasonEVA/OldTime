//
//  CalendarNewTimeDateSelectTableViewCell.h
//  launcher
//
//  Created by William Zhang on 15/7/31.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  📅候补时间选择带时分选择器

#import <UIKit/UIKit.h>
#import "CalendarTimeSelectDefine.h"

typedef void(^calendarNewTimeSelectedSegmentIndexBlock)(id cell, NSUInteger selectedIndex);

@interface CalendarNewTimeDateSelectTableViewCell : UITableViewCell

+ (NSString *)identifier;
+ (CGFloat)height;

/** 选择时间标题，是否显示删除按钮 */
- (void)setTitle:(NSString *)title showTrash:(BOOL)showTrash;

/// 显示全天选择switch
- (void)showAllDaySwitch;

/** 删除以及时间变化的回调 */
- (void)setDeleteBlock:(CalendarNewTimeDeleteBlock)block didChange:(CalendarNewTimeDidChangeBlock)didChangeBlock;
- (void)selectedSegmentIndexBlock:(calendarNewTimeSelectedSegmentIndexBlock)selecteBlock;

- (void)switchDay:(void(^)())switchBlock;

- (void)setStartDate:(NSDate *)date endData:(NSDate *)endDate;
- (void)isSelectedStartSegment:(BOOL)isSelect;

@end
