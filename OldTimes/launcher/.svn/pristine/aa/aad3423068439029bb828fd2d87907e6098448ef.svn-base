//
//  UIColor+Hex.m
//  launcher
//
//  Created by William Zhang on 15/7/24.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)


+ (UIColor *)mtc_colorWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b {
    return [UIColor mtc_colorWithR:r g:g b:b alpha:1.0];
}

+ (UIColor *)mtc_colorWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:r / 255.0
                           green:g / 255.0
                            blue:b / 255.0
                           alpha:alpha];
}

+ (UIColor *)mtc_colorWithHex:(NSInteger)hexValue
{
    return [UIColor mtc_colorWithHex:hexValue alpha:1.0];
}
+ (UIColor*)mtc_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alphaValue];
}

+ (UIColor *)mtc_colorWithW:(NSInteger)w {
    return [UIColor mtc_colorWithW:w alpha:1.0];
}

+ (UIColor *)mtc_colorWithW:(NSInteger)w alpha:(CGFloat)alpha {
    return [UIColor colorWithWhite:w / 255.0 alpha:alpha];
}

@end

@implementation UIColor (LaunchrApp)
+ (UIColor *)themeBlue  { return [self mtc_colorWithHex:0x0099ff];}
+ (UIColor *)themeRed   { return [self mtc_colorWithHex:0xff3366];}
+ (UIColor *)themeGreen { return [self mtc_colorWithHex:0x22c064];}
+ (UIColor *)themeGray  { return [self mtc_colorWithW:143];}

+ (UIColor *)cellTitleGray  { return [self mtc_colorWithHex:0x707070];}
+ (UIColor *)grayBackground { return [self mtc_colorWithW:235];}

+ (UIColor *)mediumFontColor { return [self mtc_colorWithW:102];}
+ (UIColor *)minorFontColor  { return [self mtc_colorWithW:153];}

+ (UIColor *)borderColor { return [self mtc_colorWithW:204];}

+ (UIColor *)buttonHighlightColor { return [self mtc_colorWithW:235];}

+ (UIColor *)atUserOtherColor { return [self mtc_colorWithHex:0xfab56b];}
+(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
