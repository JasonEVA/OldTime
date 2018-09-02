//
//  Triangle.m
//  launcher
//
//  Created by conanma on 15/12/17.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "Triangle.h"

@implementation Triangle
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *aColor = [UIColor whiteColor];
//    aColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:1];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    
    CGFloat borderOffset = 1.5;//阴影偏移量
    UIColor *borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];//阴影的颜色
    
    CGPoint sPoints[3];//坐标点
    sPoints[0] =CGPointMake(4.5, 0);//坐标1
    sPoints[1] =CGPointMake(0, 5);//坐标2
    sPoints[2] =CGPointMake(9, 5);//坐标3
    
    CGContextSetRGBStrokeColor(context, 202.0/255, 202.0/255, 202.0/255, 0.3);  //颜色
    CGContextAddLines(context, sPoints, 3);//添加线
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), borderOffset, borderColor.CGColor);//阴影
//    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextClosePath(context);//封起来
    

    
    
    CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
//

}
-(void)drawNow
{
    [self setNeedsDisplay];
}
@end
