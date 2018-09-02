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
//主题颜色
+ (UIColor*) mainThemeColor;
//背景颜色
+ (UIColor*) commonBackgroundColor;

//常规控件border颜色
+ (UIColor*) commonControlBorderColor;

//常规字体颜色
+ (UIColor*) commonTextColor;

//常规浅色字体颜色
+ (UIColor*) commonLightGrayTextColor;

+ (UIColor*) commonDarkGrayTextColor;
//分割线颜色
+ (UIColor*) commonCuttingLineColor;

+ (UIColor*) commonGrayTextColor;
//滚轮背景颜色 － 灰
+ (UIColor*) commonPickViewBackGroundColor;
//点击高亮
+ (UIColor*) commonGrayTouchHihtLightColor;
//自定义蓝色
+ (UIColor*) commonBlueColor;
//自定义绿色
+ (UIColor*) commonGreenColor;
//自定义橙色
+ (UIColor*) commonOrangeColor;
//自定义紫色
+ (UIColor*) commonVioletColor;
//自定义红色
+ (UIColor*) commonRedColor;
@end
