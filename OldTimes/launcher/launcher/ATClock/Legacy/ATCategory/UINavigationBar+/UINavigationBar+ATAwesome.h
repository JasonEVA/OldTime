//
//  UINavigationBar+Awesome.h
//  LTNavigationBar
//
//  Created by ltebean on 15-2-15.
//  Copyright (c) 2015 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (ATAwesome)
- (void)at_setBackgroundColor:(UIColor *)backgroundColor;
- (void)at_setElementsAlpha:(CGFloat)alpha;
- (void)at_setTranslationY:(CGFloat)translationY;
- (void)at_reset;
@end