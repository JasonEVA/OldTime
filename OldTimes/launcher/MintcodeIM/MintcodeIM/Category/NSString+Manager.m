//
//  NSString+Manager.m
//  BeautyView
//
//  Created by Remon Lv on 14-5-20.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "NSString+Manager.h"

@implementation NSString (Manager)

// 根据 ‘\n’ 符号剥离字符串
+ (NSArray *)peelStringWithLineBreak:(NSString *)string
{
    NSMutableArray *arr_result = [NSMutableArray array];
    NSRange range = [string rangeOfString:@"\n"];
    // 没有分行符就直接返回数组
    if (range.length == 0)
    {
        [arr_result addObject:string];
        return arr_result;
    }
    // 至少有一个分行符就进入循环筛选
    while (1)
    {
        NSString *str_peel = [string substringToIndex:range.location];
        [arr_result addObject:str_peel];
        // 判断是否到达边界
        if (range.location + range.length >= string.length - 2)
        {
            return arr_result;
        }
        string = [string substringFromIndex:range.location + range.length];
        range = [string rangeOfString:@"\n"];
        // 最后一个分行符了
        if (range.length == 0)
        {
            [arr_result addObject:string];
            return arr_result;
        }
    }
}
// 转换成合理的单位
+ (NSString *)changeFileUnitFrom:(double)value
{
    NSString *unit = @"B";
    if (value > 1024)
    {
        value /= 1024;
        unit = @"K";
    }
    if (value > 1024)
    {
        value /= 1024;
        unit = @"M";
    }
    if (value > 1024)
    {
        value /= 1024;
        unit = @"G";
    }
    return [NSString stringWithFormat:@"%.1f%@",value,unit];
}

// 生成当前时间戳的字符串
+ (NSString *)convertCurrentDateTimeToString
{
    return [NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]];
}

// SQLite插入特殊字符转义
+ (NSString *)convertSpecialCharInString:(NSString *)string
{
    if ([string isKindOfClass:[NSNull class]] || string == nil) return @"";

    return [string stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}

/*
 * URL 编码，把 NSString 中的特殊字符转义掉
 */
+ (NSString *)encodeURLWithStringEncodingUTF8:(NSString *)string
{
    NSString *newString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), kCFStringEncodingUTF8));
    if (newString) {
        return newString;
    }
    return @"";
}

+ (NSString *)removeBlankInString:(NSString *)oldString OnlyMarginal:(BOOL)onlyMarginal
{
    NSString *strNew = @"";
    if (oldString != nil)
    {
        if (onlyMarginal)
        {
            strNew = [oldString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        else
        {
            strNew = [oldString stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
    }
    return strNew;
}

+ (BOOL)checkValuableWithString:(NSString *)string
{
    if (string != nil)
    {
        if (string.length > 0)
        {
            NSString *stringResult = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (stringResult.length > 0)
            {
                return YES;
            }
        }
    }
    return NO;
}

/**
 *  判断是否是Http网络路径
 *
 *  @param string 输入路径
 *
 *  @return 是Http网络路径就返回YES
 */
- (BOOL)checkHttpUrlWithString
{
    if (self != nil)
    {
        if ([self hasPrefix:@"http://"])
        {
            return YES;
        }
    }
    return NO;
}

/**
 *  是否包含一个字符串
 *
 *  @param aString 关键字（连续的）
 *
 *  @return 结果
 */
- (BOOL)isContainsString:(NSString *)aString
{
    if ([self respondsToSelector:@selector(containsString:)])
    {
        return [self containsString:aString];
    }
    else
    {
        NSRange rangeResult = [self rangeOfString:aString];
        return rangeResult.length > 0;
    }
}

@end
