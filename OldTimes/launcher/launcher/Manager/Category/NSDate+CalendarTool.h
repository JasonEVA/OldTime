//
//  NSDate+CalendarTool.h
//  launcher
//
//  Created by kylehe on 16/3/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  日历📅时间工具

#import <Foundation/Foundation.h>

@interface NSDate (CalendarTool)
/**
 *  获取当前时间月份的第几天
 */
+ (NSInteger)mtc_day:(NSDate *)date;
/**
 *  获取当前时间的月份
 */
+ (NSInteger)mtc_month:(NSDate *)date;
/**
 *  获取当前的时间的年份
 */
+ (NSInteger)mtc_year:(NSDate *)date;
/**
 *  获取当前时间的总月份
 */
+ (NSInteger)mtc_totalDaysInMonth:(NSDate *)date;
/**
 *  获取当前时间上一个月的某一天
 */
+ (NSDate *)mtc_lastMonth:(NSDate *)date;
/**
 *  获取当前时间下个月的某一天
 */
+ (NSDate *)mtc_nextMonth:(NSDate *)date;
/**
 * 获取第一天是周几
 */
+ (NSInteger)mtc_firstWeekdayInThisMonth:(NSDate *)date;


@end
