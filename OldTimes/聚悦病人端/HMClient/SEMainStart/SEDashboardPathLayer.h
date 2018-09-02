//
//  SEDashboardPathLayer.h
//  HMClient
//
//  Created by JasonWang on 2017/5/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface SEDashboardPathLayer : CALayer
- (void)configCircleRadius:(CGFloat)circleRadius lineWidth:(CGFloat)lineWidth circleBGColcor:(UIColor *)circleBGColor highlightColor:(UIColor *)highlightColor  maskColor:(UIColor *)maskColor;

- (void)configBackCircleAngle:(CGFloat)backCircleAngle highlightCircleAngle:(CGFloat)highlightCircleAngle;

@end
