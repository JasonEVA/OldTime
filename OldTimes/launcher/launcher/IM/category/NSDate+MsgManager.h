//
//  NSDate+Manager.h
//  Parenting Strategy
//
//  Created by Remon Lv on 14-5-27.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  NSDate自定义扩展方法

#import <Foundation/Foundation.h>

@interface NSDate (MsgManager)

/// 计算时间格式（无必要不拼接小时分钟）
+ (NSString *)im_dateFormaterWithTimeInterval:(long long)timeInterval;
/**
 *  计算时间格式
 *
 *  @param timeInterval 正常时间戳*1000
 *
 *  @param appendMinute 是否拼接上小时分钟
 *  @return 2015-01-12 13:57
 */
+ (NSString *)im_dateFormaterWithTimeInterval:(long long)timeInterval appendMinute:(BOOL)appendMinute;
/**
 *  计算时间格式
 *
 *  @param timeInterval 正常时间戳*1000
 *  @param showWeek     是否显示显示周几
 *  @param appendMinute 是否拼接上小时分钟
 *
 *  @return 2015-01-12(周一) 13:57
 */
+ (NSString *)im_dateFormaterWithTimeInterval:(long long)timeInterval showWeek:(BOOL)showWeek appendMinute:(BOOL)appendMinute;


+ (NSString *)calendarFormaterWithTimeIntervalWith:(long long)timeInterval;

//日期转为星期几
+ (NSString *)weekdayStringFromDate:(NSDate *)inputDate;

//时间戳转HH:mm
+ (NSString *)timeStringFromlong:(long long)date;

//计算两个时间戳的时间差
+ (NSString *)compareTwoTime:(long long)time1 time2:(long long)time2;

@end
