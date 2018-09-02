//
//  ChatRightImageTableViewCell.h
//  Titans
//
//  Created by Andrew Shen on 14-9-24.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  右边图片聊天Cell

#import <UIKit/UIKit.h>
#import "MessageBaseModel.h"

@interface ChatRightImageTableViewCell : UITableViewCell<UIAlertViewDelegate>
{
    UIActivityIndicatorView *_loadingIndicator; // 旋转指示器
    UIImageView *_imgViewBubble;    // 气泡
    UIImageView *_imgViewHeadIcon;  // 头像
    UIImageView *_imgViewImage;    // 图片
    UIImageView *_imgViewFailed;    // 失败图标
    UIImageView *_imgViewReaded;                // 已读
    UIActivityIndicatorView *_viewIndicator;    // 旋转指示器
    UILabel     *_lbTime;                       // 时间
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier HeadIcon:(NSString *)imgUrl Target:(id)target ActionTap:(SEL)actionTap ActionLong:(SEL)actionLong ActionFail:(SEL)actionFail ActionHead:(SEL)actionHead;

// 显示图片（从服务器同步下来的）
- (void)showReceiveImageMessage:(NSString *)imageUrl Tag:(NSInteger)tag;

// 显示图片（本地发送的）
- (void)showSendImageMessage:(UIImage *)image Tag:(NSInteger)tag;

// 设置状态
- (void)showStatus:(Msg_status)status;

// 显示位置截图
- (void)showPositionMessage:(UIImage *)image Tag:(NSInteger)tag;

// 显示时间
- (void)showDate:(NSString *)time;

// 显示已读未读标记
- (void)isReaded:(NSInteger)readed;

@end
