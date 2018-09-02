//
//  ChatLeftTextTableViewCell.h
//  Titans
//
//  Created by Andrew Shen on 14-9-22.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  左边文字聊天cell

#import <UIKit/UIKit.h>

@interface ChatLeftTextTableViewCell : UITableViewCell
{
    UIImageView *_imgViewHeadIcon;  // 头像
    UIImageView *_imgViewBubble;    // 气泡
    UILabel     *_lbText;           // 消息内容
    UILabel     *_lbName;           // 姓名
    UILabel     *_lbTime;           // 时间
    UIImageView *_imgEmphasis;      // 重点标记标志
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Target:(id)target ActionHead:(SEL)actionHead ActionLong:(SEL)actionLong;

// 显示消息
- (void)showTextMessage:(NSString *)message;

// 设置头像
- (void)setHeadIconWithUrl:(NSString *)imgUrl Tag:(NSInteger)tag;

// 设置姓名
- (void)setRealName:(NSString *)name hidden:(BOOL)hidden;

// 显示时间
- (void)showDate:(NSString *)time;

//设置重点标志(是否展示)
- (void)setEmphasisIsShow:(BOOL)IsShow;

@end
