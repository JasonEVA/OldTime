//
//  NSDate+Date.m
//  launcher
//
//  Created by Dee on 16/8/5.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NSDate+Date.h"

@implementation NSDate (Date)

+ (NSDate *)getDate:(id)date
{
    if ([date isKindOfClass:[NSNumber class]]) {
        return [NSDate dateWithTimeIntervalSince1970:[date longLongValue]/1000];
    }
    return date;
}

+ (BOOL)mtc_dateIsValidDate:(NSDate *)date {
	return [date mtc_isValidDate];
}

- (BOOL)mtc_isValidDate {
    return [self timeIntervalSince1970] > 0;
}

+ (long long)getTimeStamp:(NSDate *)date
{
    return (long long)[date timeIntervalSince1970] * 1000;
}

@end
