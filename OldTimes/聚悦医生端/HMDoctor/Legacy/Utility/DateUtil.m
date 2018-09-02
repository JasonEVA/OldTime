//
//  DateUtil.m
//  Shape
//
//  Created by Andrew Shen on 15/11/5.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+ (NSCalendar *)calendar {
    static NSCalendar *calendar;
    if (!calendar) {
        calendar = [NSCalendar currentCalendar];
    }
    return calendar;
}

+ (NSDateFormatter *)formatter {
    static NSDateFormatter *formatter;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    return formatter;
}

// 获取某日期前/后几天日期
+ (NSDate *)dateFromDate:(NSDate *)fromDate intervalDay:(NSInteger)intervalDay {
    NSCalendar *calendar = [self calendar];
    NSDateComponents *compnents = [[NSDateComponents alloc] init];
    compnents.day = intervalDay;
    NSDate *myDate = [calendar dateByAddingComponents:compnents toDate:fromDate options:0];
    return myDate;

}

// 指定Date包含的单位
+ (NSDate *)dateWithComponents:(NSCalendarUnit)unitFlags date:(NSDate *)date {
    NSCalendar *calendar = [self calendar];
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSDate *myDate = [calendar dateFromComponents:comps];
    return myDate;
}

// 将Date转为String
+ (NSString *)stringDateWithDate:(NSDate *)date dateFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [self formatter];
    [dateFormatter setDateFormat:format];
    NSString *result = [dateFormatter stringFromDate:date];
    return result;
}

/**
 *  获得日期的NSDateComponents
 */
+ (NSDateComponents *)dateComponentsForDate:(NSDate *)date {
    NSCalendar *calendar = [self calendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitQuarter fromDate:date];
    return comps;
}

/**
 *  将时长秒数转换为带角标的分秒string格式
 *
 *  @param integer 时长（秒）
 *
 *  @return 带角标的分秒string
 */
+ (NSString *)stringWithSecond:(long)timeinterval{
    NSString *string = [NSString stringWithFormat:@"%ld\'%ld\"",timeinterval / 60,timeinterval % 60];
    return string;
}

// 将string转Date
+ (NSDate *)convertDateFromString:(NSString*)uiDate
{
    return [self convertDateFromString:uiDate formatString:@"yyyy-MM-dd"];
}

// 将一定格式string转Date
+ (NSDate *)convertDateFromString:(NSString*)dateString formatString:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

// 转为yy-MM-dd
+ (NSString *)stringDateFormatedDate:(NSDate *)date {
    return [self stringDateWithDate:date dateFormat:@"yyyy-MM-dd"];
}

@end
