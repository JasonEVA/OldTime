//
//  GraphicLockView.h
//  launcher
//
//  Created by William Zhang on 15/7/28.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  手势解锁

#import <UIKit/UIKit.h>

@protocol GraphicLockViewDelegate <NSObject>

@optional
/** 解锁回调，返回密码是否正确 */
- (BOOL)GraphicLockViewDelegateCallBack_finishWithPassword:(NSArray *)password;

/** 密码设置，迷你密码图实时变化 */
- (void)GraphicLockViewDelegateCallBack_touchUpWithPassword:(NSArray *)password;

@end

@interface GraphicLockView : UIView

@property (nonatomic, weak) id<GraphicLockViewDelegate> delegate;
@property (nonatomic, assign) BOOL isSecond;
- (void)clearColorAndSelectedButton;
@end
