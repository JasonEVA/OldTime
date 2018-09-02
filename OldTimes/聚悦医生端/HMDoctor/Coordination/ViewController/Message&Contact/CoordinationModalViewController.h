//
//  CoordinationModalViewController.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//  自定义弹框

#import "HMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CoordinationModalViewControllerDelegate <NSObject>

//- (void)coordinationModalViewControllerDelegateCallBack_clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)coordinationModalViewControllerDelegateCallBack_clickedButtonAtIndex:(NSInteger)buttonIndex Tag:(NSInteger)tag;

@end
@interface CoordinationModalViewController : HMBaseViewController

@property (nonatomic, weak)  id<CoordinationModalViewControllerDelegate>  delegate; // <##>

@property(nonatomic, assign) NSInteger  tag;

// 多按钮后续支持
- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(id<CoordinationModalViewControllerDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)addInputView:(UIView *)view height:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END