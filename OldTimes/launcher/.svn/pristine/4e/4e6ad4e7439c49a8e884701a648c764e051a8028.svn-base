//
//  ChatRightVideoTableViewCell.h
//  PalmDoctorPT
//
//  Created by Lars Chen on 15/7/6.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//  右边视频Cell

#import <UIKit/UIKit.h>
#import <MintcodeIM/MintcodeIM.h>

@interface ChatRightVideoTableViewCell : UITableViewCell
{
    UIActivityIndicatorView *_loadingIndicator; // 旋转指示器
    UIImageView *_imgViewBubble;    // 气泡
    UIImageView *_imgViewHeadIcon;  // 头像
    UIImageView *_imgViewImage;    // 图片
    UIImageView *_imgViewFailed;    // 失败图标
    UIActivityIndicatorView *_viewIndicator;    // 旋转指示器
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier HeadIcon:(NSString *)imgUrl Target:(id)target ActionTap:(SEL)actionTap ActionLong:(SEL)actionLong ActionFail:(SEL)actionFail ActionHead:(SEL)actionHead;

// 显示图片（从服务器同步下来的）
- (void)showReceiveImageMessage:(NSString *)imageUrl Tag:(NSInteger)tag;

// 显示图片（本地发送的）
- (void)showSendImageMessageBaseModel:(MessageBaseModel *)model Tag:(NSInteger)tag;

// 设置状态
- (void)showStatus:(Msg_status)status;

@end
