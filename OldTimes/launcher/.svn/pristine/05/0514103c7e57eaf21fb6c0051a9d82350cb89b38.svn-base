//
//  NSString+HandleEmoji.h
//  launcher
//
//  Created by Dee on 16/7/28.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HandleEmoji)

- (BOOL)isEmoji;

- (BOOL)isIncludingEmoji;

- (instancetype)stringByRemovingEmoji;

+ (BOOL)stringContainsEmoji:(NSString *)string  NS_DEPRECATED_IOS(5_0, 6_0,"Use -isIncludingEmoji instead of this method");

//去除Emoji表情
+ (NSString*)disable_EmojiString:(NSString *)text NS_DEPRECATED_IOS(5_0, 6_0,"Use -stringByRemovingEmoji instead of this method");

@end
