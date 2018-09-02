//
//  MeFooterView.m
//  Shape
//
//  Created by jasonwang on 15/11/17.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeFooterView.h"
#import "UIColor+Hex.h"

@implementation MeFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(70, 0)];
    [path addLineToPoint:CGPointMake(70, self.frame.size.height)];
    [path setLineWidth:1];
    [[UIColor themeBackground_373737] setStroke];
    [path stroke];
}
@end
