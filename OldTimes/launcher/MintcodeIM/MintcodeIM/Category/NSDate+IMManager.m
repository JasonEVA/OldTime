//
//  NSDate+IMManager.m
//  MintcodeIM
//
//  Created by williamzhang on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NSDate+IMManager.h"
#import <DateTools/NSDate+DateTools.h>

@implementation NSDate (IMManager)

+ (long long)wzim_currentTimestamp {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    return (long long)(timeInterval * 1000);
}

+ (NSString *)wzim_dateFormaterWithTimeInterval:(long long)timeInterval {
    return [self wzim_dateFormaterWithTimeInterval:timeInterval appendMinute:NO];
}
+ (NSString *)wzim_dateFormaterWithTimeInterval:(long long)timeInterval appendMinute:(BOOL)appendMinute {
    return [self wzim_dateFormaterWithTimeInterval:timeInterval showWeek:NO appendMinute:appendMinute];
}

+ (NSString *)wzim_dateFormaterWithTimeInterval:(long long)timeInterval showWeek:(BOOL)showWeek appendMinute:(BOOL)appendMinute {
    // 将时间戳转换为标准时间
    NSDate *compareDate = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000.0];
    NSDate *currentDate = [NSDate date];
    
    NSString *weekDay = @"";
    if (showWeek) {
        static NSDateFormatter *dateFormatter = nil;
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
        }

        dateFormatter.dateFormat = @"(EEE)";
        weekDay = [dateFormatter stringFromDate:compareDate];
    }
    
    
    BOOL compareYear = compareDate.year == currentDate.year;
    BOOL compareMonth = compareDate.month == currentDate.month;
    BOOL compareDay = compareDate.day == currentDate.day;
    
    NSString *yearString   = [NSString stringWithFormat:@"%ld",   compareDate.year];
    NSString *monthString  = [NSString stringWithFormat:@"%02ld", compareDate.month];
    NSString *dayString    = [NSString stringWithFormat:@"%02ld", compareDate.day];
    NSString *hourString   = [NSString stringWithFormat:@"%02ld", compareDate.hour];
    NSString *minuteString = [NSString stringWithFormat:@"%02ld", compareDate.minute];
    
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

@end
