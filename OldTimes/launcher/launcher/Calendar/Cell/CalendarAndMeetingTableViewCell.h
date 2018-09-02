//
//  CalendarAndMeetingTableViewCell.h
//  launcher
//
//  Created by William Zhang on 15/8/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  日程会议选择场所 cell

#import <UIKit/UIKit.h>

@interface CalendarAndMeetingTableViewCell : UITableViewCell

+ (NSString *)identifier;
+ (CGFloat)height;

/**
 *  设置属性
 *
 *  @param title    标题
 *  @param subTitle 子标题
 *  @param selected 选中（选中状态下子标题显示默认文字）
 */
- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle selected:(BOOL)selected;

@end
