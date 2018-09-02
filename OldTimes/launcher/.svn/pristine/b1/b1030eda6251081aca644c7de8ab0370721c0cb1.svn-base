//
//  NSDate+ATCompare.m
//  Clock
//
//  Created by SimonMiao on 16/7/20.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "NSDate+ATCompare.h"

@implementation NSDate (ATCompare)

+ (BOOL)at_compareFromeDate:(NSNumber *)timeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longValue]];
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//NSGregorianCalendar
    //    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    //    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDate *now = [NSDate date];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
        NSComparisonResult result = [calendar compareDate:now toDate:date toUnitGranularity:unitFlags];
        if (result == NSOrderedSame) {
            return YES;
        }
        else{
            return NO;
        }
        
    }
    else{
        NSComparisonResult result = [date compare:now];
        if (result == NSOrderedSame) {
            return YES;
        }
        else{
            return NO;
        }
    }
}

/** 获取某一天固定时刻的时间NSDate */
+ (NSDate *)at_getEveryDayMomentDateWithHour:(NSInteger)hour {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    components.hour = hour;
    
    
    NSDate *momentDate = [calendar dateFromComponents:components];
    
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setLocale:locale];
//    [formatter setDateFormat:@"yyyy-MM-dd HH"];
//    NSString *dateStr = [NSString stringWithFormat:@"%li-%li-%li %li",(long)components.year,(long)components.month,(long)components.day,(long)hour];
//    NSDate *momentDate = [formatter dateFromString:dateStr];
    
    
    return momentDate;
}

@end
