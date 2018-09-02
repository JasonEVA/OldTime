//
//  DashboardPathLayer.m
//  AnimationDemo
//
//  Created by Andrew Shen on 2016/11/11.
//  Copyright © 2016年 AndrewShen. All rights reserved.
//

#import "DashboardPathLayer.h"

@interface DashboardPathLayer()
@property (nonatomic, strong)  UIColor  *circleBGColor; // <##>
@property (nonatomic, strong)  UIColor  *highlightColor; // <##>
@property (nonatomic, strong)  UIColor  *maskColor; // <##>
@property (nonatomic, assign)  CGFloat  circleRadius; // 圆半径
@property (nonatomic, assign)  CGFloat  lineWidth; // 圆路径宽度
@property (nonatomic, assign)  CGFloat  backCircleAngle; // 背景圆角度
@property (nonatomic, assign)  CGFloat  highlightCircleAngle; // 高亮圆角度

@end

@implementation DashboardPathLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.circleRadius = 52.5;
        self.lineWidth = 20;
        self.circleBGColor = [UIColor redColor];
        self.highlightColor = [UIColor greenColor];
        self.maskColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.2];
        self.backCircleAngle = 2 * M_PI;
        self.highlightCircleAngle = M_PI;
    }
    return self;
}


- (void)configCircleRadius:(CGFloat)circleRadius lineWidth:(CGFloat)lineWidth circleBGColcor:(UIColor *)circleBGColor highlightColor:(UIColor *)highlightColor  maskColor:(UIColor *)maskColor {
    self.circleRadius = circleRadius;
    self.lineWidth = lineWidth;
    self.circleBGColor = circleBGColor;
    self.highlightColor = highlightColor;
    self.maskColor = maskColor;
}

- (void)configBackCircleAngle:(CGFloat)backCircleAngle highlightCircleAngle:(CGFloat)highlightCircleAngle {
    self.backCircleAngle = backCircleAngle;
    self.highlightCircleAngle = highlightCircleAngle;
}



- (void)drawInContext:(CGContextRef)ctx {
    CGFloat radius = self.circleRadius - self.lineWidth * 0.5;
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);

    UIBezierPath *pathBG = [UIBezierPath bezierPath];
    [pathBG addArcWithCenter:center radius:radius startAngle:-(self.backCircleAngle * 0.5 + M_PI_2 * 3.05 / 3) endAngle:self.backCircleAngle * 0.5 - M_PI_2 * 3.05 / 3 clockwise:YES];
    CGContextAddPath(ctx, pathBG.CGPath);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetStrokeColorWithColor(ctx, self.circleBGColor.CGColor);
    CGContextStrokePath(ctx);
    
    UIBezierPath *pathHighlight = [UIBezierPath bezierPath];
    [pathHighlight addArcWithCenter:center radius:radius startAngle:-(self.highlightCircleAngle * 0.5 + M_PI_2) endAngle:self.highlightCircleAngle * 0.5 - M_PI_2 clockwise:YES];
    CGContextAddPath(ctx, pathHighlight.CGPath);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetStrokeColorWithColor(ctx, self.highlightColor.CGColor);
    CGContextStrokePath(ctx);

    UIBezierPath *pathMask = [UIBezierPath bezierPath];
    [pathMask moveToPoint:center];
    [pathMask addArcWithCenter:center radius:self.circleRadius - self.lineWidth startAngle:-(self.highlightCircleAngle * 0.5 + M_PI_2) endAngle:self.highlightCircleAngle * 0.5 - M_PI_2 clockwise:YES];
    CGContextAddPath(ctx, pathMask.CGPath);
    CGContextSetFillColorWithColor(ctx, self.maskColor.CGColor);
    CGContextFillPath(ctx);
}
@end
