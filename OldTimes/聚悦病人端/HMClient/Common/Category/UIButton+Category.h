//
//  UIButton+Category.h
//  HMClient
//
//  Created by lkl on 2017/8/31.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Category)

/**
 *  扩大 UIButton 的點擊範圍
 *  控制上下左右的延長範圍
 *
 *  @param top    上
 *  @param right  右
 *  @param bottom 下
 *  @param left   左
 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end
