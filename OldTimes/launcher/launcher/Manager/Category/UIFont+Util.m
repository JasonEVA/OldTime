//
//  UIFont+Util.m
//  launcher
//
//  Created by williamzhang on 15/11/24.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "UIFont+Util.h"

@implementation UIFont (Util)

+ (UIFont *)mtc_font_30 { return [self fontWithSize:15];}
+ (UIFont *)mtc_font_28 { return [self fontWithSize:14];}
+ (UIFont *)mtc_font_26 { return [self fontWithSize:13];}
+ (UIFont *)mtc_font_24 { return [self fontWithSize:12];}
+ (UIFont *)mtc_font_22 { return [self fontWithSize:11];}
+ (UIFont *)mtc_font_20 { return [self fontWithSize:10];}
+ (UIFont *)fontWithSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size];
}

@end
