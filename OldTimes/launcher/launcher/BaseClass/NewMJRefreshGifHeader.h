//
//  NewMJRefreshGifHeader.h
//  launcher
//
//  Created by Lars Chen on 16/1/13.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  自定义Header 动画更改

#import "MJRefreshStateHeader.h"

@interface NewMJRefreshGifHeader : MJRefreshStateHeader
/** 设置state状态下的动画图片images 动画持续时间duration*/
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state;
- (void)setImages:(NSArray *)images forState:(MJRefreshState)state;
@end
