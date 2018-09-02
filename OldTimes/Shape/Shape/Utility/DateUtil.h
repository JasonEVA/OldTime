//
//  DateUtil.h
//  Shape
//
//  Created by Andrew Shen on 15/11/5.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

// 获取某日期前/后几天日期
+ (NSDate *)dateFromDate:(NSDate *)fromDate intervalDay:(NSInteger)intervalDay;

// 指定Date包含的单位
+ (NSDate *)dateWithComponents:(NSCalendarUnit)unitFlags date:(NSDate *)date;

// 将Date转为String
+ (NSString *)stringDateWithDate:(NSDate *)date dateFormat:(NSString *)format;

/**
 *  获得日期的NSDateComponents
 */
+ (NSDateComponents *)dateComponentsForDate:(NSDate *)date;

@end
