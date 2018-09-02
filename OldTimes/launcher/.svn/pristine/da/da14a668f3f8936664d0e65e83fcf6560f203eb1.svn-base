//
//  NSString+HandleEmoji.m
//  launcher
//
//  Created by Dee on 16/7/28.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NSString+HandleEmoji.h"

static NSCharacterSet *VariationSelectors = nil;
@implementation NSString (HandleEmoji)

+ (void)load {
	VariationSelectors = [NSCharacterSet characterSetWithRange:NSMakeRange(0xFE00, 16)];
}

- (BOOL)isEmoji {
	if ([self rangeOfCharacterFromSet: VariationSelectors].location != NSNotFound) {
		return YES;
	}
	
	const unichar high = [self characterAtIndex: 0];
	
	// Surrogate pair (U+1D000-1F9FF)
	if (0xD800 <= high && high <= 0xDBFF) {
		const unichar low = [self characterAtIndex: 1];
		const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
		
		return (0x1D000 <= codepoint && codepoint <= 0x1F9FF);
		
		// Not surrogate pair (U+2100-27BF)
	} else {
		return (0x2100 <= high && high <= 0x27BF);
	}
}

- (BOOL)isIncludingEmoji {
	BOOL __block result = NO;
	
	[self enumerateSubstringsInRange:NSMakeRange(0, [self length])
							 options:NSStringEnumerationByComposedCharacterSequences
						  usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
							  if ([substring isEmoji]) {
								  *stop = YES;
								  result = YES;
							  }
						  }];
	
	return result;
}

- (instancetype)stringByRemovingEmoji {
	NSMutableString* __block buffer = [NSMutableString stringWithCapacity:[self length]];
	
	[self enumerateSubstringsInRange:NSMakeRange(0, [self length])
							 options:NSStringEnumerationByComposedCharacterSequences
						  usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
							  [buffer appendString:([substring isEmoji])? @"": substring];
						  }];
	
	return buffer;
}

//是否含有表情
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
	
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}
//去除Emoji表情
+ (NSString*)disable_EmojiString:(NSString *)text
{
    //去除表情规则
    //  \u0020-\\u007E  标点符号，大小写字母，数字
    //  \u00A0-\\u00BE  特殊标点  (¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾)
    //  \u2E80-\\uA4CF  繁简中文,日文，韩文 彝族文字
    //  \uF900-\\uFAFF  部分汉字
    //  \uFE30-\\uFE4F  特殊标点(︴︵︶︷︸︹)
    //  \uFF00-\\uFFEF  日文  (ｵｶｷｸｹｺｻ)
    //  \u2000-\\u201f  特殊字符(‐‑‒–—―‖‗‘’‚‛“”„‟)
    // 注：对照表 http://blog.csdn.net/hherima/article/details/9045765

    
    NSRegularExpression* expression = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString* result = [expression stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:@""];
    
    
    return result;
}

@end
