//
//  NSString+TaskStringFormat.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/14.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "NSString+TaskStringFormat.h"

@implementation NSString (TaskStringFormat)

// 将@"|"分隔的String转为顿号分隔的String
- (NSString *)hm_formatCuttingLineStringSeparatedByPeriodString {
    if (self.length == 0) {
        return @"";
    }
    NSMutableString *stringTemp = [self mutableCopy];
    NSString *seperator = @"|";
    if ([stringTemp hasPrefix:seperator]) {
        [stringTemp deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    if ([stringTemp hasSuffix:seperator]) {
        [stringTemp deleteCharactersInRange:NSMakeRange(stringTemp.length - 1, 1)];
    }
    return [stringTemp stringByReplacingOccurrencesOfString:seperator withString:@"、"];
}

// 将@"|"分隔的String转为数组
- (NSArray *)hm_convertCuttingLineStringToArrayComponentsSeparatedByPeriodString {
    NSString *newString = [self hm_formatCuttingLineStringSeparatedByPeriodString];
    if (newString.length == 0) {
        return nil;
    }
    NSArray *arr = [newString componentsSeparatedByString:@"、"];
    return arr;
}

@end
