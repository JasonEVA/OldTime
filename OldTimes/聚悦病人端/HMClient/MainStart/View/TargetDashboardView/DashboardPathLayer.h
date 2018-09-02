//
//  DashboardPathLayer.h
//  AnimationDemo
//
//  Created by Andrew Shen on 2016/11/11.
//  Copyright © 2016年 AndrewShen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface DashboardPathLayer : CALayer

- (void)configCircleRadius:(CGFloat)circleRadius lineWidth:(CGFloat)lineWidth circleBGColcor:(UIColor *)circleBGColor highlightColor:(UIColor *)highlightColor  maskColor:(UIColor *)maskColor;

- (void)configBackCircleAngle:(CGFloat)backCircleAngle highlightCircleAngle:(CGFloat)highlightCircleAngle;
@end
