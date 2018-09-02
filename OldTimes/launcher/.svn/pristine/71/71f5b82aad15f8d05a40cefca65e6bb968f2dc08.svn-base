//
//  ChatRightTextTableViewCell.h
//  Titans
//
//  Created by Andrew Shen on 14-9-22.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  右边文字聊天cell

#import <UIKit/UIKit.h>
#import "MessageBaseModel.h"

@interface ChatRightTextTableViewCell : UITableViewCell<UIAlertViewDelegate>
{
    UIActivityIndicatorView *_loadingIndicator; // 旋转指示器
    UIImageView *_imgViewHeadIcon;              // 头像
    UIImageView *_imgViewBubble;                // 气泡
    UIImageView *_imgViewFailed;                // 失败图标
    UIImageView *_imgViewReaded;                // 已读
    UILabel     *_lbText;                       // 消息内容
    UILabel     *_lbTime;                       // 时间
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier HeadIcon:(NSString *)imgUrl Target:(id)target Action:(SEL)action ActionFail:(SEL)actionFail ActionHead:(SEL)actionHead;

// 显示消息
- (void)showTextMessage:(NSString *)message;

// 设置状态
- (void)showStatus:(Msg_status)status;

// 显示时间
- (void)showDate:(NSString *)time;

// 显示已读未读标记
- (void)isReaded:(NSInteger)readed;

@end
