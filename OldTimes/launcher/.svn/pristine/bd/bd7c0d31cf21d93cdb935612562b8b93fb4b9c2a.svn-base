//
//  NSDate+Manager.m
//  Parenting Strategy
//
//  Created by Remon Lv on 14-5-27.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "NSDate+MsgManager.h"
#import <DateTools/NSDate+DateTools.h>
#import "UnifiedUserInfoManager.h"

@implementation NSDate (MsgManager)

//日期转为星期几
+ (NSString *)weekdayStringFromDate:(NSDate *)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null],
                         LOCAL(CALENDAR_SCHEDULEBYWEEK_SUNDAY),
                         LOCAL(CALENDAR_SCHEDULEBYWEEK_MONDAY),
                         LOCAL(CALENDAR_SCHEDULEBYWEEK_TUESTDAY),
                         LOCAL(CALENDAR_SCHEDULEBYWEEK_WEDNESDAY),
                         LOCAL(CALENDAR_SCHEDULEBYWEEK_THURSDAY),
                         LOCAL(CALENDAR_SCHEDULEBYWEEK_FRIDAY),
                         LOCAL(CALENDAR_SCHEDULEBYWEEK_SATURDAY),nil];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
//    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
//    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

+ (NSString *)im_dateFormaterWithTimeInterval:(long long)timeInterval {
    return [self im_dateFormaterWithTimeInterval:timeInterval appendMinute:NO];
}
+ (NSString *)im_dateFormaterWithTimeInterval:(long long)timeInterval appendMinute:(BOOL)appendMinute {
    return [self im_dateFormaterWithTimeInterval:timeInterval showWeek:NO appendMinute:appendMinute];
}

+ (NSString *)im_dateFormaterWithTimeInterval:(long long)timeInterval showWeek:(BOOL)showWeek appendMinute:(BOOL)appendMinute {
    // 将时间戳转换为标准时间
    NSDate *compareDate = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000.0];
    NSDate *currentDate = [NSDate date];

    NSString *weekDay = @"";
    if (showWeek) {
        NSLocale *currentLocale = [[UnifiedUserInfoManager share] getLocaleIdentifier];
        static NSDateFormatter *dateFormatter = nil;
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
        }
        dateFormatter.locale = currentLocale;
        dateFormatter.dateFormat = @"(EEE)";
        weekDay = [dateFormatter stringFromDate:compareDate];
    }
    
    
    BOOL compareYear = compareDate.year == currentDate.year;
    BOOL compareMonth = compareDate.month == currentDate.month;
    BOOL compareDay = compareDate.day == currentDate.day;
    
    NSString *yearString   = [NSString stringWithFormat:@"%ld",   (long)compareDate.year];
    NSString *monthString  = [NSString stringWithFormat:@"%02ld", (long)compareDate.month];
    NSString *dayString    = [NSString stringWithFormat:@"%02ld", (long)compareDate.day];
    NSString *hourString   = [NSString stringWithFormat:@"%02ld", (long)compareDate.hour];
    NSString *minuteString = [NSString stringWithFormat:@"%02ld", (long)compareDate.minute];
    
    NSString *dateFormat = [NSString stringWithFormat:@"%@/%@/%@%@",yearString, monthString, dayString, weekDay];

    if (compareYear && compareMonth && compareDay) {
        // 今天
        dateFormat = [NSString stringWithFormat:@"%@:%@",hourString, minuteString];
    }
    
    else if (compareYear && (!compareMonth || ! compareDay)) {
        // 今年
        dateFormat = [NSString stringWithFormat:@"%@/%@%@",monthString, dayString, weekDay];
        if (appendMinute) {
            dateFormat = [dateFormat stringByAppendingFormat:@" %@:%@",hourString, minuteString];
        }
    }
    
    else if (!compareYear) {
        // 不是今年
        if (appendMinute) {
            dateFormat = [dateFormat stringByAppendingFormat:@" %@:%@",hourString, minuteString];
        }
    }
    
    return dateFormat;
}

+ (NSString *)calendarFormaterWithTimeIntervalWith:(long long)timeInterval
{
    // 将时间戳转换为标准时间
    NSDate *compareDate = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000.0];
    NSString *weekDay = @"";
    NSLocale *currentLocale = [[UnifiedUserInfoManager share] getLocaleIdentifier];
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    dateFormatter.locale = currentLocale;
    dateFormatter.dateFormat = @"EEE";
    weekDay = [dateFormatter stringFromDate:compareDate];
    
    return [NSString stringWithFormat:@"%ld年%02ld月%02ld日 %@",(long)compareDate.year,(long)compareDate.month,(long)compareDate.day,weekDay];
}

//时间戳转HH:mm
+ (NSString *)timeStringFromlong:(long long)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:date/1000];
    return [dateFormatter stringFromDate:date1];
    
}

//时间戳转MM:dd
+ (NSString *)dateStringFromlong:(long long)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:date/1000];
    return [dateFormatter stringFromDate:date1];
    
}

//计算两个时间戳的时间差
+ (NSString *)compareTwoTime:(long long)time1 time2:(long long)time2
{
    NSTimeInterval balance = time2 / 1000 - time1 / 1000;
    NSString *timeString = @"";
    
    timeString = [NSString stringWithFormat:@"%f",balance / 60];
    timeString = [timeString substringToIndex:timeString.length - 7];
    
    NSInteger timeInt = [timeString intValue];
    NSInteger timeHourMint = timeInt % (24 * 60);
    NSInteger day = timeInt / (24 * 60);
    NSInteger hour = timeHourMint / 60;
    NSInteger mint = timeHourMint % 60;
    
    if (day == 0) {
        if (hour == 0) {
            timeString = [NSString stringWithFormat:@"%ld%@",(long)mint, LOCAL(CALENDAR_MINUTE)];
        }
        else
        {
            if (mint == 0) {
                timeString = [NSString stringWithFormat:@"%ld%@",(long)hour, LOCAL(CALENDAR_HOUR)];
            }
            else
            {
                timeString = [NSString stringWithFormat:@"%ld%@%ld%@",(long)hour, LOCAL(CALENDAR_HOUR),(long)mint, LOCAL(CALENDAR_MINUTE)];
            }
        }
    }
    else
    {
        timeString = [NSString stringWithFormat:@"%ld天%ld%@%ld%@",(long)day,(long)hour, LOCAL(CALENDAR_HOUR),(long)mint, LOCAL(CALENDAR_MINUTE)];
    }
    
    return timeString;
}
@end
