//
//  UIColor+Hex.h
//  launcher
//
//  Created by William Zhang on 15/7/24.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)


+ (UIColor *)mtc_colorWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b;
+ (UIColor *)mtc_colorWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b alpha:(CGFloat)alpha;

+ (UIColor *)mtc_colorWithHex:(NSInteger)hexValue;
+ (UIColor *)mtc_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

+ (UIColor *)mtc_colorWithW:(NSInteger)w;
+ (UIColor *)mtc_colorWithW:(NSInteger)w alpha:(CGFloat)alpha;

@end

@interface UIColor (LaunchrApp)

/**
 *  0x0099ff
 *  (0,153,255)
 */
+ (UIColor *)themeBlue;
/**
 *  0xff3366
 *  (255,51,102)
 */
+ (UIColor *)themeRed;
/**
 *  0x8f8f8f
 *  (143,143,143)
 */
+ (UIColor *)themeGray;
/**
 *  0X22C064
 *  (34,192,100)
 */
+ (UIColor *)themeGreen;
/**
 *  0x707070
 *  (112,112,112)
 */
+ (UIColor *)cellTitleGray;
/**
 *  0xebebeb
 *  (235,235,235)
 */
+ (UIColor *)grayBackground;

/**
 *  中级
 *  0x666666
 *  (102,102,102)
 */
+ (UIColor *)mediumFontColor;
/**
 *  低级
 *  0x999999
 *  (153,153,153)
 */
+ (UIColor *)minorFontColor;

/**
 *  边框
 *  0xcccccc
 *  @return (204,204,204)
 */
+ (UIColor *)borderColor;

/**
 *  按钮高亮
 *  0xebebeb
 *  @return (235,235,235)
 */
+ (UIColor *)buttonHighlightColor;

/**
 *  别人@颜色
 *  0xfab56b
 *  @return (250,181,107)
 */
+ (UIColor *)atUserOtherColor;
/**
 *  随机色
 *
 */
+(UIColor *) randomColor;
@end
