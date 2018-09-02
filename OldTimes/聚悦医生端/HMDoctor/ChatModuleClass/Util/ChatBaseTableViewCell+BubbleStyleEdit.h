//
//  ChatBaseTableViewCell+BubbleStyleEdit.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/9/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//  卡片样式更改分类

#import "ChatBaseTableViewCell.h"

@interface ChatBaseTableViewCell (BubbleStyleEdit)

// 气泡填充颜色
- (void)ats_changeBubbleTintColor:(UIColor *)tintColor;

// 更改气泡背景
- (void)ats_changeBubbleBackgroundImage:(UIImage *)image;
@end
