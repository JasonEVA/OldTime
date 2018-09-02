//
//  Slacker.h
//  Parenting Strategy
//
//  Created by Remon Lv on 14-5-23.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  懒虫方法

#import <UIKit/UIKit.h>

@interface Slacker : NSObject

// ****************** 泛用 ********************

// 计算UI的frame的x+width 或者y+height BOOL为真计算横向 否则计算纵向
+ (CGFloat)getValueWithFrame:(CGRect)rect WithX:(BOOL)remon;

// 移动UI到点(duration <= 0,duration = 0.25)
+ (void)moveUI:(UIView *)view ToPoint:(CGPoint)point Duration:(CGFloat)duration;

// 水波纹动画
+ (CATransition *)animationWaterWithDuration:(CGFloat)duration;

// 翻页动画
+ (void)animationFlipPageToNext:(BOOL)isNext Target:(UIView *)target;

// 膨胀特效(对象、膨胀比例、时长、起始透明度)
+ (void)fadeInForTarget:(UIView *)target Scale:(CGSize)size Duration:(CGFloat)duration Alpha:(CGFloat)alpha;

//image旋转
+ (UIImage *)convertImage:(UIImage *)image Rotation:(UIImageOrientation)orientation;

/**
 *  获取View在自身坐标系的center
 *
 *  @param view 需要获取坐标的view
 *
 *  @return 相对于自身坐标系的中心点
 */
+ (CGPoint)getOwnBoundsCenterForView:(UIView *)view;

// 打印网络请求二进制结果码的方法
+ (void)printHttpPostResultWith:(NSData *)data;

// ****************** 本App使用 ********************

/**
 * 打印 Frame
 */
+ (NSString *)printFrame:(CGRect)frame WithMessage:(NSString *)msg;

/**
 * 得到从小屏向大屏转换时候的 XMargin
 */
+ (CGFloat)getXMarginFrom320ToNowScreen;

/**
 * 得到从小屏向大屏转换时候的 YMargin
 */
+ (CGFloat)getYMarginFrom320ToNowScreen;

/**
 *  压缩图片
 */
+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
