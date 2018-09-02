//
//  UIColor+Common.m
//  HMDoctor
//
//  Created by yinquan on 16/4/11.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "UIColor+Common.h"

@implementation UIColor (Common)

+ (UIColor*) mainThemeColor
{
    UIColor* themeColor = [UIColor colorWithHexString:@"3DCABA"];
    return themeColor;
}

+ (UIColor*) commonTranslucentColor
{
    UIColor* commonTranslucentColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    return commonTranslucentColor;
}

//背景颜色
+ (UIColor*) commonBackgroundColor
{
    UIColor* bgColor = [UIColor colorWithHexString:@"F0F0F0"];
    return bgColor;
}

//常规控件border颜色
+ (UIColor*) commonControlBorderColor
{
    UIColor* borderColor = [UIColor colorWithHexString:@"dfdfdf"];
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
    UIColor* textColor = [UIColor colorWithHexString:@"cccccc"];
    return textColor;
}

//分割线颜色
+ (UIColor*) commonCuttingLineColor
{
    UIColor* textColor = [UIColor colorWithHexString:@"dfdfdf"];
    return textColor;
}

+ (UIColor*) commonDarkGrayTextColor
{
    UIColor* textColor = [UIColor colorWithHexString:@"666666"];
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
//自定义红色
+ (UIColor*) commonRedColor
{
    UIColor* textColor = [UIColor colorWithHexString:@"FF6666"];
    return textColor;
}
@end
