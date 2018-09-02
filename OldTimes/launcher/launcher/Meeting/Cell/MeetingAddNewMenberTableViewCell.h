//
//  MeetingAddNewMenberTableViewCell.h
//  launcher
//
//  Created by Conan Ma on 15/8/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//
#import <UIKit/UIKit.h>

@class MeetingAddNewMenberTableViewCell;

@interface MeetingAddNewMenberTableViewCell : UITableViewCell

@property (nonatomic, readonly) UILabel *myTextLabel;     //必须参加 label

+ (NSString *)identifier;
/**
 *  计算字符串组合后的高度
 *
 *  @param strings           字符串数组
 *  @param showMore          是否显示更多
 *  @param accessoryTypeMode 是否有accessoryType显示
 *
 *  @return 返回计算后的高度
 */
+ (CGFloat)heightFromArrayString:(NSArray *)strings
                        showMore:(BOOL)showMore
               accessoryTypeMode:(BOOL)accessoryTypeMode;

- (void)dataWithStrings:(NSArray *)strings showMore:(BOOL)showMore;

@end
