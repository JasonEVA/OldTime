//
//  UIColor+Common.m
//  HMDoctor
//
//  Created by yinquan on 16/4/11.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "UIColor+Common.h"

@implementation UIColor (Common)

+ (UIColor*) commonTranslucentColor
{
    UIColor* commonTranslucentColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    return commonTranslucentColor;
}

/********************** 标准色 *****************************/

+ (UIColor*) mainThemeColor
{
    UIColor* themeColor = [UIColor colorWithHexString:@"0099FF"];
    return themeColor;
}

+ (UIColor *)commonRedColor {
    UIColor *color = [UIColor colorWithHexString:@"FF6666"];
    return color;
}


//背景颜色
+ (UIColor*) commonBackgroundColor
{
    UIColor* bgColor = [UIColor colorWithHexString:@"F0F0F0"];
    return bgColor;
}

+ (UIColor *)commonDarkGrayColor_666666 {
    return [UIColor colorWithHexString:@"666666"];
}

+ (UIColor *)commonBlackTextColor_333333 {
    return [UIColor colorWithHexString:@"333333"];
}

+ (UIColor *)commonLightGrayColor_999999 {
    return [UIColor colorWithHexString:@"999999"];
}

+ (UIColor *)commonLightGrayColor_dddddd {
    return [UIColor colorWithHexString:@"dddddd"];
}

+ (UIColor *)commonLightGrayColor_ebebeb {
    return [UIColor colorWithHexString:@"ebebeb"];
}

+ (UIColor *)commonYellewColor_ffac4f {
    return [UIColor colorWithHexString:@"ffac4f"];
}
/********************** 以下暂未用到 *****************************/



//常规控件border颜色
+ (UIColor*) commonControlBorderColor
{
    UIColor* borderColor = [UIColor colorWithHexString:@"DDDDDD"];
    return borderColor;
}

//常规字体颜色
+ (UIColor*) commonTextColor
{
    UIColor* textColor = [UIColor colorWithHexString:@"333333"];
    return textColor;
}

//常规字体颜色
+ (UIColor*) commonLightGrayTextColor
{
    UIColor* textColor = [UIColor colorWithHexString:@"B8B8B8"];
    return textColor;
}

// 分割线颜色
+ (UIColor *)commonSeperatorColor_dfdfdf {
    return [UIColor colorWithHexString:@"dfdfdf"];
}

// 滑动事件按钮
+ (UIColor *)commonOrangeColor_ff8636 {
    return [UIColor colorWithHexString:@"ff8636"];
}


//分割线颜色
+ (UIColor*) commonCuttingLineColor
{
    UIColor* textColor = [UIColor colorWithHexString:@"dddddd"];
    return textColor;
}

+ (UIColor*) commonDarkGrayTextColor
{
    UIColor* textColor = [UIColor colorWithHexString:@"666666"];
    return textColor;
}

+ (UIColor *) systemLineColor_c8c7cc
{
    UIColor* textColor = [UIColor colorWithHexString:@"dcdcdc"];
    return textColor;
}

+ (UIColor*) commonGrayTextColor
{
    UIColor* textColor = [UIColor colorWithHexString:@"999999"];
    return textColor;
}

+ (UIColor*) commonGrayTouchHihtLightColor
{
    UIColor* textColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    return textColor;
}

+ (UIColor*) commonPickViewBackGroundColor
{
    UIColor* pickerViewColor = [UIColor colorWithRed:0.82 green:0.84 blue:0.86 alpha:1.00];
    return pickerViewColor;
}

+ (UIColor*) commonBlueColor
{
    UIColor* textColor = [UIColor colorWithHexString:@"4AB0FF"];
    return textColor;
}

+ (UIColor*) commonGreenColor
{
    UIColor* textColor = [UIColor colorWithHexString:@"2ECC71"];
    return textColor;
}



//自定义橙色
+ (UIColor*) commonOrangeColor
{
    UIColor* textColor = [UIColor colorWithHexString:@"FFa63C"];
    return textColor;
}
//自定义红紫色
+ (UIColor*) commonVioletColor
{
    UIColor* textColor = [UIColor colorWithHexString:@"FF6098"];
    return textColor;
}

@end
