//
//  UIColor+Common.h
//  HMDoctor
//
//  Created by yinquan on 16/4/11.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Common)

//半透明颜色
+ (UIColor*) commonTranslucentColor;
/********************** 标准色 *****************************/
//主题颜色
+ (UIColor*) mainThemeColor;
+ (UIColor *)commonRedColor;

//背景颜色
+ (UIColor*) commonBackgroundColor;


+ (UIColor *)commonDarkGrayColor_666666;

// 标题色
+ (UIColor *)commonBlackTextColor_333333;

+ (UIColor *)commonLightGrayColor_999999;

// 深分割线
+ (UIColor *)commonLightGrayColor_dddddd;
+ (UIColor *) systemLineColor_c8c7cc;
// 浅分割线
+ (UIColor *)commonLightGrayColor_ebebeb;
//中等黄色
+ (UIColor *)commonYellewColor_ffac4f ;

// 分割线颜色
+ (UIColor *)commonSeperatorColor_dfdfdf;

+ (UIColor*) commonGrayTouchHihtLightColor;
+ (UIColor*) commonPickViewBackGroundColor;

// 滑动事件按钮
+ (UIColor *)commonOrangeColor_ff8636;

/********************** 以下暂未用到 *****************************/

//常规控件border颜色
+ (UIColor*) commonControlBorderColor;

//常规字体颜色
+ (UIColor*) commonTextColor;

//常规字体颜色
+ (UIColor*) commonLightGrayTextColor;


+ (UIColor*) commonDarkGrayTextColor;
//分割线颜色
+ (UIColor*) commonCuttingLineColor;

+ (UIColor*) commonGrayTextColor;

//自定义蓝色
+ (UIColor*) commonBlueColor;
//自定义绿色
+ (UIColor*) commonGreenColor;
//自定义橙色
+ (UIColor*) commonOrangeColor;
//自定义紫色
+ (UIColor*) commonVioletColor;


@end
