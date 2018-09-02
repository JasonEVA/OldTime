//
//  NSDate+String.m
//  launcher
//
//  Created by William Zhang on 15/8/13.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "NSDate+String.h"
#import <DateTools/DateTools.h>
#import "UnifiedUserInfoManager.h"
#import "MyDefine.h"

static NSDateFormatter *dateFormatter = nil;

@implementation NSDate (String)

- (NSString *)mtc_startToEndDate:(NSDate *)endDate {
    return [self mtc_startToEndDate:endDate wholeDay:NO];
}

- (NSString *)mtc_startToEndDate:(NSDate *)endDate wholeDay:(BOOL)isWholeDay {
    NSString *string = @"";
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    dateFormatter.locale = [[UnifiedUserInfoManager share] getLocaleIdentifier];
    
    NSString *startString, *endString;
    
    if (isWholeDay) {
        // 全天模式
        dateFormatter.dateFormat = @"MM/dd(EEEEE)";
        startString = [dateFormatter stringFromDate:self];
        endString   = [dateFormatter stringFromDate:endDate];
        if (self.year == endDate.year && self.month == endDate.month && self.day == endDate.day) {
            return startString;
        }else if (self.year != endDate.year)
        {
            dateFormatter.dateFormat = @"yyyy/MM/dd(EEEEE)";
            if (endDate.year != self.year)
            {
                startString = [dateFormatter stringFromDate:self];
                endString   = [dateFormatter stringFromDate:endDate];
            }
        }
    }
    else {
        // 不是全天模式
		if (self.year != endDate.year)
		{
			dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
		} else {
			dateFormatter.dateFormat = @"MM/dd(EEEEE) HH:mm";
		}

        startString = [dateFormatter stringFromDate:self];
        
        // 判断是不是start end是同一天,则改变
        if (self.day == endDate.day && self.year == endDate.year && self.month == endDate.month) {
            dateFormatter.dateFormat = @"HH:mm";
        }
//        else if (self.year != endDate.year)
//        {
//            dateFormatter.dateFormat = @"yyyy/MM/dd(EEEEE) HH:mm";
//            NSDate *today = [NSDate date];
//            if (today.year != self.year)
//            {
//                startString = [dateFormatter stringFromDate:self];
//            }
//        }
        
        endString = [dateFormatter stringFromDate:endDate];
    }
    
    string = [NSString stringWithFormat:@"%@～%@", startString, endString];
    return string;
}

- (NSDate *)mtc_calculatorMinuteIntervalDidChange:(NSNumber *__autoreleasing *)didChange {
    return [self mtc_calculatorMinuteInterval:5 didChange:didChange];
}

- (NSDate *)mtc_calculatorMinuteInterval:(NSInteger)interval didChange:(NSNumber *__autoreleasing *)didChange{
    if (didChange) {
        *didChange = @NO;
    }
    
    NSInteger miniteInterval = self.minute % interval;
    if (!miniteInterval) {
        return self;
    }
    
    if (didChange) {
        *didChange = @YES;
    }
    
    NSInteger needAddMinite = interval - miniteInterval;
    NSDate *dateModified = [self dateByAddingMinutes:needAddMinite != interval ? needAddMinite : 0];
    
    return dateModified;
}

+ (NSDate *)dateByCalculatorMinuteIntervalDidChange:(NSNumber *__autoreleasing *)didChange {
    return [self dateByCalculatorMinuteInterval:5 didChange:didChange];
}

+ (NSDate *)dateByCalculatorMinuteInterval:(NSInteger)interval didChange:(NSNumber *__autoreleasing *)didChange {
    return [[NSDate date] mtc_calculatorMinuteInterval:interval didChange:didChange];
}

- (NSString *)mtc_dateFormate {
    return [self mtc_dateFormateWithWeekDay:NO];
}
- (NSString *)mtc_dateFormateWithWeekDay:(BOOL)showWeekDay {
    NSString *dateString = @"";
    
    NSDate *currentDate = [NSDate date];
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    dateFormatter.locale = [[UnifiedUserInfoManager share] getLocaleIdentifier];
    dateFormatter.dateFormat = @"(EEE)";
    NSString *weakDayString = [dateFormatter stringFromDate:self];
    if (!showWeekDay) {
        weakDayString = @"";
    }
    
    if (self.year == currentDate.year &&
        self.month == currentDate.month &&
        self.day == currentDate.day) {
        if (self.hour == 0 && self.minute == 0)
        {
            dateString = [NSString stringWithFormat:@"%ld/%ld", (long)self.month,(long)self.day];
        }else
        {
            dateString = [NSString stringWithFormat:@"%@%@ %02ld:%02ld",LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY), weakDayString,(long)self.hour, (long)self.minute];
        }
    } else {
        if (self.hour == 0 && self.minute == 0)
        {
            dateString = [NSString stringWithFormat:@"%ld/%ld", (long)self.month,(long)self.day];
        }else
        {
            dateString = [NSString stringWithFormat:@"%ld/%ld%@ %02ld:%02ld",(long)self.month, (long)self.day, weakDayString, (long)self.hour, (long)self.minute];
        }
        if (self.year != currentDate.year) {
            dateString = [NSString stringWithFormat:@"%ld %@",(long)self.year, dateString];
        }
    }

    return dateString;
}

- (NSString *)mtc_getStringWithDateWholeDay:(BOOL)isWholeDay {
    return [self mtc_getStringWithDateWholeDay:isWholeDay showWeekDay:NO];
}

- (NSString *)mtc_getStringWithDateWholeDay:(BOOL)isWholeDay showWeekDay:(BOOL)showWeekDay {
    NSDate *today = [NSDate date];
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    dateFormatter.locale = [[UnifiedUserInfoManager share] getLocaleIdentifier];
    
    NSString *startString;
    NSString *dateFormat = @"";
    
    if (self.year != today.year) {
        dateFormat = [dateFormat stringByAppendingString:@"yyyy/MM/dd"];
    } else {
        dateFormat = [dateFormat stringByAppendingString:@"MM/dd"];
    }
    
    if (showWeekDay) {
        dateFormat = [dateFormat stringByAppendingString:@"(EEE)"];
    }
    
    if (!isWholeDay) {
        dateFormat = [dateFormat stringByAppendingString:@" HH:mm"];
    }
    
    dateFormatter.dateFormat = dateFormat;
    startString = [dateFormatter stringFromDate:self];
    return startString;
}

+ (BOOL)mtc_dateIsWholeDayWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
	return startDate.hour == 0 &&
	startDate.minute == 0 &&
	startDate.second == 0 &&
	endDate.hour == 0 &&
	endDate.minute == 0 &&
	endDate.second == 0
	;
}


+ (NSString *)mtc_getDateStrWihtDate:(NSDate *)date isWholeDay:(BOOL)isWholeDay
{
    NSString *dateStr = @"";
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    NSDate *currnetDate = [NSDate date];
    
    dateFormatter.locale = [[UnifiedUserInfoManager share] getLocaleIdentifier];
    if (isWholeDay) {  //全天状态下 －－ 不显示时刻
        //跨年判断
        if (currnetDate.year != date.year)
        {
            dateFormatter.dateFormat = @"yyyy/MM/dd";
        } else {
            dateFormatter.dateFormat = @"MM/dd(EEEEE)";
        }
    }else              //非全天状态下 －－ 显示时刻
    {
        if (currnetDate.year != date.year)
        {
            dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
        } else {
            dateFormatter.dateFormat = @"MM/dd(EEEEE) HH:mm";
        }
    }
    dateStr = [dateFormatter stringFromDate:date]; // 进行时间转换
    return dateStr;
}

-(NSString *)getClockTime {
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"HH:mm"];
	NSString *clockTime = [df stringFromDate:self];
	return clockTime;
	
}
@end
