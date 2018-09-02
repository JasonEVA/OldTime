//
//  RedPoint.m
//  launcher
//
//  Created by Jason Wang on 15/9/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "RedPoint.h"

@implementation RedPoint

- (instancetype)init
{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //创建一个圆
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddArc(context, self.frame.size.width / 2, self.frame.size.height / 2, self.frame.size.width / 2, 0,M_PI * 2, 0);
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextDrawPath(context, kCGPathFill);
}


@end
