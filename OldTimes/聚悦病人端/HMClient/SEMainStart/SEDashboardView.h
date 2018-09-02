//
//  SEDashboardView.h
//  HMClient
//
//  Created by JasonWang on 2017/5/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//  第二版仪表盘

#import <UIKit/UIKit.h>

@interface SEDashboardView : UIView
@property (nonatomic, strong)  UIImageView  *pointerView; // <##>

- (void)configCircleRadius:(CGFloat)circleRadius lineWidth:(CGFloat)lineWidth circleBGColcor:(UIColor *)circleBGColor highlightColor:(UIColor *)highlightColor  maskColor:(UIColor *)maskColor;

- (void)configBackCircleAngle:(CGFloat)backCircleAngle highlightCircleAngle:(CGFloat)highlightCircleAngle;

- (void)animatePointWithAngle:(CGFloat)angle;
@end
