//
//  BaseViewController.h
//  MintTeam
//
//  Created by William Zhang on 15/7/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  ViewController基类

#import "UIViewController+Loading.h"

@interface BaseViewController : UIViewController

/** 获得当前显示在屏幕上的页面 */
+ (UIViewController *)presentingVC;

/** 设置导航栏左上角标数字 */
- (void)leftItemNumber:(NSInteger)number;
/// 根据数据库中内容改变导航栏左上角标数字，若要改变，自行继承
- (void)changeLeftNumber;

/**
 *  显示导航栏左按钮
 *
 *  @param selector selector为nil时自动替换为默认方法及样式
 */
- (void)showLeftItemWithSelector:(SEL)selector;

/** 禁用左滑手势 */
- (void)popGestureDisabled:(BOOL)disabled;

//记录日志
- (void)RecordToDiary:(NSString *)string;

- (void)TimerStart;

- (void)TimerStartStart;

- (void)TimerEndWithString:(NSString *)string;


@end
