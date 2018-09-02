//
//  NSDate+StringFromToday.m
//  HMViewMgrDemo
//
//  Created by yinqaun on 16/3/31.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NSDate+StringFromToday.h"

#define kStandardDateTimeFormat         @"yyyy-MM-dd HH:mm:ss"
#define kStandardDateFormat         @"yyyy-MM-dd"
#define kStandardTimeFormat         @"HH:mm:ss"

@implementation NSDate (StringFromToday)

+ (NSDate*) dateFromStandardDateTimeString:(NSString*) dateString
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:kStandardDateTimeFormat];
    NSDate* date = [formatter dateFromString:dateString];
    return date;
}

+ (NSDate*) dateFromeStandardDateString:(NSString*) dateString
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:kStandardDateFormat];
    NSDate* date = [formatter dateFromString:dateString];
    return date;
}

- (NSString*) datetimeStringWithStandardFormat
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:kStandardDateTimeFormat];
    NSString* datetimeString = [formatter stringFromDate:self];
    return datetimeString;
    
}

- (NSString*) dateStringWithStandardFormat
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:kStandardDateFormat];
    NSString* dateString = [formatter stringFromDate:self];
    return dateString;
    
}

- (NSString*) timeStringWithStandardFormat
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:kStandardTimeFormat];
    NSString* timeString = [formatter stringFromDate:self];
    return timeString;
    
}



@end
