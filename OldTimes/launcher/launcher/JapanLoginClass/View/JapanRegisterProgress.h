//
//  JapanRegisterProgress.h
//  launcher
//
//  Created by williamzhang on 16/4/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  日本注册进度条

#import <UIKit/UIKit.h>

@interface JapanRegisterProgress : UIView

- (instancetype)initWithTotalProgress:(NSUInteger)progress;

- (void)setProgress:(NSUInteger)progress;

@end
