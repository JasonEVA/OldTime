//
//  LeftTriangle.m
//  launcher
//
//  Created by 马晓波 on 16/2/23.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "LeftTriangle.h"
#import "UIColor+Hex.h"

@interface LeftTriangle()
@property (nonatomic, strong) UIColor *mybackColor;
@property (nonatomic, strong) UIColor *myBorderColor;
@end

@implementation LeftTriangle
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.mybackColor = [UIColor mtc_colorWithHex:0xe8f6f1];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame WithColor:(UIColor *)color
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.mybackColor = color;
    }
    return self;
}

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
    
    UIColor *borderColor = [UIColor mtc_colorWithHex:0xa7e1cc];
    
    CGPoint sPoints[3];//坐标点
    sPoints[0] =CGPointMake(0, 24);//坐标1
    sPoints[1] =CGPointMake(8, 18);//坐标2
    sPoints[2] =CGPointMake(8, 30);//坐标3
    
//    CGContextSetRGBStrokeColor(context, 202.0/255, 202.0/255, 202.0/255, 0.3);  //颜色
    CGContextSetRGBStrokeColor(context, 232.0/255, 2246.0/255, 241.0/255, 1);  //颜色
    CGContextAddLines(context, sPoints, 3);//添加线
//    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), borderOffset, borderColor.CGColor);//阴影
//        CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextClosePath(context);//封起来
    
    CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
    
    CGContextRef contextd = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(contextd, 1.5);
    
    [self.myBorderColor set];

    CGContextBeginPath(contextd);
    
    CGContextMoveToPoint(contextd, 0, 24);
    CGContextAddLineToPoint(contextd, 8, 18);
    
    CGContextMoveToPoint(contextd, 0, 24);
     CGContextAddLineToPoint(contextd, 8, 30);
    
    CGContextStrokePath(contextd);
    
}

-(void)drawNow
{
    self.mybackColor = [UIColor mtc_colorWithHex:0xe8f6f1];
    [self setNeedsDisplay];
}

@end
