//
//  BaseViewController.h
//  MintTeam
//
//  Created by William Zhang on 15/7/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  ViewController基类

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/** 获得当前显示在屏幕上的页面 */
+ (UIViewController *)presentingVC;

@property (nonatomic, readonly, getter=isLoading) BOOL loading;

#pragma mark - Success
- (void)postSuccess;
- (void)postSuccess:(NSString *)message;
- (void)postSuccess:(NSString *)message overTime:(NSTimeInterval)second;

#pragma mark - Error
- (void)postErrorFromNumber:(NSInteger)errorNumber DEPRECATED_ATTRIBUTE;

- (void)postError:(NSString *)message;
- (void)postError:(NSString *)message duration:(CGFloat)duration;
- (void)postError:(NSString *)message detailMessage:(NSString *)detailMessage duration:(CGFloat)duration;

#pragma mark - Loading
- (void)postProgress:(float)progress;
- (void)postLoading;
- (void)postLoading:(NSString *)message;
- (void)postLoading:(NSString *)title message:(NSString *)message;
- (void)postLoading:(NSString *)title message:(NSString *)message overTime:(NSTimeInterval)second;

#pragma mark - Hide
- (void)hideLoading;

@end
