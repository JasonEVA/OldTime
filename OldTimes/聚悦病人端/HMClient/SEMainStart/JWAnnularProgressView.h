//
//  JWAnnularProgressView.h
//  HMClient
//
//  Created by jasonwang on 2017/8/9.
//  Copyright © 2017年 YinQ. All rights reserved.
//  环形进度条

#import <UIKit/UIKit.h>

@interface JWAnnularProgressView : UIView

/**
 初始化环形进度条方法

 @param frame 传入frame
 @param circularWidth 环形进度条宽度
 @param circularBackColor 环形进度条背景色
 @param circularProgressColor 环形进度条进度颜色
 @param backColor 中间填充色
 @return 环形进度条
 */
- (instancetype)initWithFrame:(CGRect)frame circularWidth:(CGFloat)circularWidth circularBackColor:(UIColor *)circularBackColor circularProgressColor:(UIColor *)circularProgressColor backColor:(UIColor *)backColor;


/**
 设置进度（百分比）

 @param progress 百分比（必须小于1大于0）
 */
- (void)configAnnularWithProgress:(CGFloat)progress;
@end
