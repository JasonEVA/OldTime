//
//  UIView+Uti.h
//  launcher
//
//  Created by William Zhang on 15/9/28.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);

@interface UIView (Util)

/**
 *  要扩张的尺寸
 */
@property (nonatomic, assign) CGSize expandSize;

/**
 *  @brief  添加tap手势
 *
 *  @param block 代码块
 */
- (void)addTapActionWithBlock:(GestureActionBlock)block;

@end
