//
//  UIColor+Hex.h
//  launcher
//
//  Created by William Zhang on 15/7/24.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)


+ (UIColor *)colorWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b;
+ (UIColor *)colorWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHex:(NSInteger)hexValue;
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

+ (UIColor *)colorWithW:(NSInteger)w;
+ (UIColor *)colorWithW:(NSInteger)w alpha:(CGFloat)alpha;

/**
 * 创建纯色的图片，用来做背景
 */
+ (UIImage *)switchToImageWithColor:(UIColor *)color size:(CGSize)size;


#pragma mark - Color Standerd
/**ThemeColor**/
+ (UIColor *)themeOrange_ff5d2b;

/**
 *  色块灰色
 */
+ (UIColor *)themeBackground_373737;
+ (UIColor *)themeGray_3c3c3c;

+ (UIColor *)themeRed_ff3c32;
+ (UIColor *)themeGreen_17b72a;

+ (UIColor *)colorWhite_ffffff;
+ (UIColor *)colorLightGray_898888;
+ (UIColor *)colorLightGray_989898;
+ (UIColor *)colorDarkGray_737272;

/**
 *  系统背景色
 */
+ (UIColor *)colorLightBlack_2e2e2e;

/**
 *  导航栏底部栏颜色
 */
+ (UIColor *)colorDarkBlack_1f1f1f;

/**
 *  系统背景色，自定义alpha
 */
+ (UIColor *)colorLightBlack_2e2e2eWithAlpha:(CGFloat)alpha;

/**
 *  导航栏底部栏颜色,自定义alpha
 */
+ (UIColor *)colorDarkBlack_1f1f1fWithAlpha:(CGFloat)alpha;

/***line**/
+ (UIColor *)lineGray_dbd8d8;
+ (UIColor *)lineDarkGray_4e4e4e;
@end
