//
//  PeriodSelectView.h
//  Shape
//
//  Created by Andrew Shen on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
// 周期选择view

#import <UIKit/UIKit.h>

@protocol PeriodSelectViewDelegate <NSObject>

// 按钮点击
- (void)PeriodSelectViewDelegateCallBack_beforeButtonClicked;
- (void)PeriodSelectViewDelegateCallBack_afterButtonClicked;

@end
@interface PeriodSelectView : UIView
@property (nonatomic, weak)  id<PeriodSelectViewDelegate>  delegate; // <##>

/**
 *  隐藏箭头
 *
 *  @param hide 左边是否隐藏
 *  @param hide 右边是否隐藏
 */
- (void)hideLeftArrow:(BOOL)leftHide rightArrow:(BOOL)rightHide;

/**
 *  设置周期title
 *
 *  @param periodTitle 周期title
 */
- (void)setPeriodTitle:(NSString *)periodTitle;

@end
