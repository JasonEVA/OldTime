//
//  MePointView.m
//  Shape
//
//  Created by jasonwang on 15/11/13.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MePointView.h"
#import "UIColor+Hex.h"

#define Radius          self.frame.size.height / 2
#define LINEWITH1       0
#define LINEWITH2       3

@implementation MePointView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(Radius,Radius) radius:Radius - LINEWITH1 startAngle:- M_PI_2 endAngle:M_PI + M_PI_2 clockwise:YES];
    [[UIColor themeBackground_373737] setFill];
    [path setLineWidth:LINEWITH1];
    [path fill];
}
@end
