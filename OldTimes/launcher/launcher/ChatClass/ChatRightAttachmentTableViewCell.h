//
//  ChatRightAttachmentTableViewCell.h
//  Titans
//
//  Created by Andrew Shen on 14-9-24.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  右边聊天附件cell

#import <UIKit/UIKit.h>
#import "MessageBaseModel.h"

@interface ChatRightAttachmentTableViewCell : UITableViewCell<UIAlertViewDelegate>
{
    UIActivityIndicatorView *_loadingIndicator; // 旋转指示器
    UIImageView *_imgViewHeadIcon;  // 头像
    UIImageView *_imgViewBubble;    // 气泡
    UIImageView *_imgViewFailed;    // 失败图标
    UIImageView *_imgViewAttachment;    // 附件图标
    UILabel     *_lbTitle;          // 附件名称
    UILabel     *_lbSize;           // 附件大小
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier HeadIcon:(NSString *)imgUrl Target:(id)target ActionTap:(SEL)actionTap ActionLong:(SEL)actionLong ActionFail:(SEL)actionFail ActionHead:(SEL)actionHead;

// 显示消息
- (void)showAttachmentType:(UIImage *)image Title:(NSString *)title Size:(NSString *)attachmentSize Tag:(NSInteger)tag;

// 设置状态
- (void)showStatus:(Msg_status)status;

@end
