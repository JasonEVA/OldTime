//
//  NSDate+String.h
//  launcher
//
//  Created by William Zhang on 15/8/13.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (String)

/**
 *  生成时间格式（所有时间）
 *
 *  @param endDate 截至时间
 *
 *  @return string  8/10（月）13:00～8/11（月）15:00
 */
- (NSString *)mtc_startToEndDate:(NSDate *)endDate;

/**
 *  生成时间格式（全天模式）
 *
 *  @param endDate    截至时间
 *  @param isWholeDay 是否是全天
 *
 *  @return string 8/10（月）～8/11（月）
 */
- (NSString *)mtc_startToEndDate:(NSDate *)endDate wholeDay:(BOOL)isWholeDay;

/**
 *  根据时间间隔计算比当前大的时间（时间间隔默认5）
 *
 *  @param didChange 是否有改变
 *
 *  @return NSDate (8:12 return 8:15)
 */
- (NSDate *)mtc_calculatorMinuteIntervalDidChange:(NSNumber **)didChange;

/**
 *  根据时间间隔计算比当前大的时间
 *
 *  @param interval  时间间隔
 *  @param didChange 是否有改变
 *
 *  @return NSDate （8:12 return 8:15 间隔为5）
 */
- (NSDate *)mtc_calculatorMinuteInterval:(NSInteger)interval didChange:(NSNumber **)didChange;

+ (NSDate *)dateByCalculatorMinuteIntervalDidChange:(NSNumber **)didChange;
+ (NSDate *)dateByCalculatorMinuteInterval:(NSInteger)interval didChange:(NSNumber **)didChange;

/**
 *  时间格式
 *
 *  @return 今日 12:30 。。 8/26 12:30
 */
- (NSString *)mtc_dateFormate;

/**
 *  时间格式
 *
 *  @param showWeekDay 是否显示星期几
 *
 *  @return 今日(一) 12:30 。。 8/26(二) 12:30
 */
- (NSString *)mtc_dateFormateWithWeekDay:(BOOL)showWeekDay;
/**
 *  时间格式
 *
 *  @param isWholeDay
 *
 *  @return 8/11
 */
- (NSString *)mtc_getStringWithDateWholeDay:(BOOL)isWholeDay;
- (NSString *)mtc_getStringWithDateWholeDay:(BOOL)isWholeDay showWeekDay:(BOOL)showWeekDay;

/**
 *  根据两个Date的时,分,秒是否全为0,判断当前时间段是否为全天时间段,如yyyy:MM:dd:00:00:00 ~ yyyy:MM:dd:00:00:00
 *  @return 如果时,分,秒都为0,返回True
 */
+ (BOOL)mtc_dateIsWholeDayWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
/**
 *  返回传入时间(NSDate类型)的字符串时间格式
 *
 *  @param date        NSDate类型 要转换的时间
 *  @param isWholeDay  是否显示全天
 *
 *  @return yyyy/MM/dd  MM/dd(EEEEE) yyyy/MM/dd HH:mm MM/dd(EEEEE) HH:mm 四种时间格式
 */
+ (NSString *)mtc_getDateStrWihtDate:(NSDate *)date isWholeDay:(BOOL)isWholeDay;

-(NSString *)getClockTime;

@end
