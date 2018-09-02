//
//  UIViewController+Loading.h
//  launcher
//
//  Created by williamzhang on 15/11/24.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  loading VC 工具类

#import <UIKit/UIKit.h>

@interface UIViewController (Loading)

@property (nonatomic, readonly, getter=isLoading) BOOL loading;
/// 控制响应开关（default:YES关闭状态）
@property (nonatomic, assign) BOOL loadingUserInteractionEnabled;

#pragma mark - Success
- (void)at_postSuccess;
- (void)at_postSuccess:(NSString *)message;
- (void)at_postSuccess:(NSString *)message overTime:(NSTimeInterval)second;

#pragma mark - Error
- (void)at_postError:(NSString *)message;
- (void)at_postError:(NSString *)message duration:(CGFloat)duration;
- (void)at_postError:(NSString *)message detailMessage:(NSString *)detailMessage duration:(CGFloat)duration;

#pragma mark - Loading
- (void)at_postProgress:(float)progress;
- (void)at_postLoading;
- (void)at_postLoadingBackgroundColor:(UIColor *)color;
- (void)at_postLoading:(NSString *)message;
- (void)at_postLoading:(NSString *)title message:(NSString *)message;
- (void)at_postLoading:(NSString *)title message:(NSString *)message overTime:(NSTimeInterval)second;

#pragma mark - Hide
- (void)at_hideLoading;

@end
