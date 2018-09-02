//
//  MeTableView.m
//  Shape
//
//  Created by jasonwang on 15/11/13.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeTableView.h"
#import "UIColor+Hex.h"

@implementation MeTableView
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(70, 100)];
    [path addLineToPoint:CGPointMake(70, self.frame.size.height)];
    [path setLineWidth:1];
    [[UIColor themeBackground_373737] setStroke];
    [path stroke];
}
    @end
