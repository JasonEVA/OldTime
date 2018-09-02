//
//  HMKeyboardShowHiddenNotificationCenter.h
//  HMDoctor
//
//  Created by lkl on 2017/9/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol HMKeyboardShowHiddenNotificationCenterDelegate <NSObject>

- (void)showOrHiddenKeyboardWithHeight:(CGFloat)height withDuration:(CGFloat)animationDuration isShow:(BOOL)isShow;

@end

@interface HMKeyboardShowHiddenNotificationCenter : NSObject

+ (HMKeyboardShowHiddenNotificationCenter *)defineCenter;

@property (nonatomic,assign) id <HMKeyboardShowHiddenNotificationCenterDelegate> delegate;

// 在对象dealloc时候调用
- (void)closeCurrentNotification;

@end
