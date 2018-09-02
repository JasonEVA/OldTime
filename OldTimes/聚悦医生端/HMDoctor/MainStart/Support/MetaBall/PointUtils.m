//
//  PointUtils.m
//  AZMetaBall
//
//  Created by 阿曌 on 16/1/3.
//  Copyright © 2016年 阿曌. All rights reserved.
//

#import "PointUtils.h"


@implementation PointUtils

+ (CGPoint)getGlobalCenterPositionOf:(UIView *)view {
    
    CGPoint point  = [self getGlobalPositionOf:view];
    
    float w = view.frame.size.width;
    float h = view.frame.size.height;

    point.x += w/2;
    point.y += h/2;
    point.y -= 64;
    
    return point;
}

+ (CGPoint)getGlobalPositionOf:(UIView *)view {
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect targetBounds = CGRectMake(view.bounds.origin.x, view.bounds.origin.y + 64, view.bounds.size.width, view.bounds.size.height);
    CGRect rect=[view convertRect: targetBounds toView:window];
    return rect.origin;
}

@end
