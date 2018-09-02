//
//  UIColor+Hex.m
//  launcher
//
//  Created by William Zhang on 15/7/24.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)


+ (UIColor *)colorWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b {
    return [UIColor colorWithR:r g:g b:b alpha:1.0];
}

+ (UIColor *)colorWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:r / 255.0
                           green:g / 255.0
                            blue:b / 255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(NSInteger)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alphaValue];
}

+ (UIColor *)colorWithW:(NSInteger)w {
    return [UIColor colorWithW:w alpha:1.0];
}

+ (UIColor *)colorWithW:(NSInteger)w alpha:(CGFloat)alpha {
    return [UIColor colorWithWhite:w / 255.0 alpha:alpha];
}

/**
 * 创建纯色的图片，用来做背景
 */
+ (UIImage *)switchToImageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *ColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ColorImg;
}




/**ThemeColor**/
+ (UIColor *)themeOrange_ff5d2b {
    return [self colorWithHex:0xff5d2b];
}
+ (UIColor *)themeBackground_373737 {
    return [self colorWithHex:0x373737];
}
+ (UIColor *)themeGray_3c3c3c {
    return [self colorWithHex:0x3c3c3c];
}



+ (UIColor *)themeRed_ff3c32 {
    return [self colorWithHex:0xff3c32];
}

+ (UIColor *)themeGreen_17b72a {
    return [self colorWithHex:0x17b72a];
}


/***font**/
+ (UIColor *)colorWhite_ffffff {
    return [self colorWithHex:0xffffff];
}

+ (UIColor *)colorLightGray_898888 {
    return [self colorWithHex:0x898888];
}

+ (UIColor *)colorDarkGray_737272 {
    return [self colorWithHex:0x737272];
}

+ (UIColor *)colorLightBlack_2e2e2e {
    return [self colorLightBlack_2e2e2eWithAlpha:1.0];
}

+ (UIColor *)colorDarkBlack_1f1f1f {
    return [self colorDarkBlack_1f1f1fWithAlpha:1.0];
}

+ (UIColor *)colorLightGray_989898{
    return [self colorWithHex:0x989898];
}
/**
 *  系统背景色，自定义alpha
 */
+ (UIColor *)colorLightBlack_2e2e2eWithAlpha:(CGFloat)alpha {
    return [self colorWithHex:0x2e2e2e alpha:alpha];
}

/**
 *  导航栏底部栏颜色,自定义alpha
 */
+ (UIColor *)colorDarkBlack_1f1f1fWithAlpha:(CGFloat)alpha {
    return [self colorWithHex:0x1f1f1f alpha:alpha];
}

/***line**/
+ (UIColor *)lineGray_dbd8d8 {
    return [self colorWithHex:0xdbd8d8];
}

+ (UIColor *)lineDarkGray_4e4e4e {
    return [self colorWithHex:0x4e4e4e];
}



@end
