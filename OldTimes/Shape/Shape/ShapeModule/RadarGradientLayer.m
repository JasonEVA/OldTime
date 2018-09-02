//
//  RadarGradientLayer.m
//  Shape
//
//  Created by Andrew Shen on 15/11/9.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "RadarGradientLayer.h"

@implementation RadarGradientLayer

- (void)drawInContext:(CGContextRef)ctx {
    UIGraphicsPushContext(ctx);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //使用RGB模式的颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //颜色空间，如果使用了RGB颜色空间则4个数字一组表示一个颜色，下面的数组表示4个颜色
    CGFloat colors[] = {1,0,0,1, 1,1,0,1, 0,1,0,1, 0,0,1,1};
    //locations代表4个颜色的分布区域（0~1），如果需要均匀分布只需要传入NULL
    CGFloat locations[]={0.125,0.375,0.625,0.875};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 4);
    //需要释放颜色空间
    CGContextDrawRadialGradient (context, gradient, self.position,
                                 0, self.position, 140,
                                 kCGGradientDrawsAfterEndLocation);
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    CGContextSaveGState(context);
    CGContextRestoreGState(context);
    UIGraphicsPopContext();
}

// 获取某个点的颜色
- (UIColor *)colorOfPoint:(CGPoint)point {
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}
@end
