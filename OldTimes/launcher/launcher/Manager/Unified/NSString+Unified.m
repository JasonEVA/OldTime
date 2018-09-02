//
//  NSString+Unified.m
//  launcher
//
//  Created by William Zhang on 15/8/20.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "NSString+Unified.h"

@implementation NSString (Unified)

+ (NSString *)wz_getSelector:(SEL)selector {
    return NSStringFromSelector(selector);
}

+ (NSString *)wz_setSelector:(SEL)selector {
    NSString *selectorName = NSStringFromSelector(selector);
    
    // 预处理
    NSString *editName = [selectorName substringFromIndex:3];
    
    NSString *firstChar = [NSString stringWithFormat:@"%c",[editName characterAtIndex:0]].lowercaseString;
    
    NSString *finalName = [NSString stringWithFormat:@"%@%@",firstChar, [editName substringFromIndex:1]];
    
    return [finalName substringToIndex:[finalName length] - 1];
}

- (NSString *)wz_firstLetterLower {
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:0]].lowercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}

- (NSString *)wz_firstLetterUpper {
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:0]].uppercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}

+ (NSString *)wz_formateFromSeconds:(NSInteger)seconds {
    NSInteger second = seconds % 60;
    seconds = seconds / 60;
    NSString *secondString = [NSString stringWithFormat:@"%02ld", (long)second];
    
    NSInteger minute = seconds % 60;
    seconds = seconds / 60;
    NSString *minuteString = [NSString stringWithFormat:@"%02ld", (long)minute];
    
    NSInteger hour = seconds % 60;
    NSString *hourString = [NSString stringWithFormat:@"%02ld", (long)hour];
    
    if (hour != 0) {
        return [NSString stringWithFormat:@"%@:%@:%@", hourString, minuteString, secondString];
    }
    
    return [NSString stringWithFormat:@"%@:%@", minuteString, secondString];
}

@end
