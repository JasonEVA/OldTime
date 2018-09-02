//
//  UIButton+EX.m
//  HMDoctor
//
//  Created by jasonwang on 16/9/10.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "UIButton+EX.h"

@implementation UIButton (EX)
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}
@end
