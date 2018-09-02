//
//  RightTriangle.m
//  launcher
//
//  Created by 马晓波 on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "RightTriangle.h"
#import "UIColor+Hex.h"

@interface RightTriangle()
@property (nonatomic, strong) UIColor *mybackColor;
@property (nonatomic, strong) UIColor *myBorderColor;
@end

@implementation RightTriangle
- (instancetype)initWithFrame:(CGRect)frame WithColor:(UIColor *)color colorBorderColor:(UIColor *)colorLine
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.mybackColor = color;
        self.myBorderColor = colorLine;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //    UIColor *aColor = [UIColor whiteColor];
    //    aColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:1];
    
    //    aColor = [UIColor mtc_colorWithHex:0xe8f6f1];
    
    CGContextSetFillColorWithColor(context, self.mybackColor.CGColor);//填充颜色
    
    CGFloat borderOffset = 1.5;//阴影偏移量
    //    UIColor *borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];//阴影的颜色
    
    UIColor *borderColor = [UIColor colorWithHex:0xa7e1cc];
    
    CGPoint sPoints[3];//坐标点
    sPoints[0] =CGPointMake(8, 14);//坐标1
    sPoints[1] =CGPointMake(0, 8);//坐标2
    sPoints[2] =CGPointMake(0, 20);//坐标3
    
    //    CGContextSetRGBStrokeColor(context, 202.0/255, 202.0/255, 202.0/255, 0.3);  //颜色
    CGContextSetRGBStrokeColor(context, 232.0/255, 2246.0/255, 241.0/255, 1);  //颜色
    CGContextAddLines(context, sPoints, 3);//添加线
    //    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), borderOffset, borderColor.CGColor);//阴影
    //        CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextClosePath(context);//封起来
    
    CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
    
    CGContextRef contextd = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(contextd, 0.5);
    
    [self.myBorderColor set];
    
    CGContextBeginPath(contextd);
    
    CGContextMoveToPoint(contextd, 8, 14);
    CGContextAddLineToPoint(contextd, 0, 8);
    
    CGContextMoveToPoint(contextd, 8, 14);
    CGContextAddLineToPoint(contextd, 0, 20);
    
    CGContextStrokePath(contextd);
    
}

-(void)drawNowWithColor:(UIColor *)color;
{
    if (!color) {
        self.mybackColor = [UIColor colorWithHex:0xe8f6f1];
    }
    else {
        if ([color isEqual:self.mybackColor]) {
            return;
        }
        self.mybackColor = color;
    }
    [self setNeedsDisplay];
}

@end
