//
//  NSString+NumberString.m
//  HMDoctor
//
//  Created by yinquan on 2017/9/27.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "NSString+NumberString.h"

@implementation NSString (NumberString)

- (BOOL) isPureInteger
{
    BOOL isInt = NO;
    NSString *regexString = @"0|[1-9][0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    isInt = [predicate evaluateWithObject:self];
    return isInt;
}

- (BOOL) isPureFloat
{
    BOOL isPureFloat = NO;
    NSString *regexString = @"[1-9][0-9]*.[0-9][0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    isPureFloat = [predicate evaluateWithObject:self];
    if (isPureFloat) {
        return isPureFloat;
    }
    
    regexString = @"0+\\.[0-9][0-9]*";
    predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    isPureFloat = [predicate evaluateWithObject:self];
    
    return isPureFloat;
}

- (BOOL) isNumberString
{
    if ([self isPureInteger]) {
        return YES;
    }
    if ([self isPureFloat]) {
        return YES;
    }
    return NO;
}

@end
