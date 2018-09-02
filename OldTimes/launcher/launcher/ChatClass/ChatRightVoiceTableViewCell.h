//
//  ChatRightVoiceTableViewCell.h
//  Titans
//
//  Created by Andrew Shen on 14-9-23.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  右边语音聊天cell

#import <UIKit/UIKit.h>
#import "MessageBaseModel.h"

@interface ChatRightVoiceTableViewCell : UITableViewCell <UIAlertViewDelegate>
{
    UIActivityIndicatorView *_loadingIndicator; // 旋转指示器
    UIImageView *_imgViewHeadIcon;  // 头像
    UIImageView *_imgViewBubble;    // 气泡
    UIImageView *_imgViewFailed;    // 失败图标
    UIImageView *_imgViewVoice;     // 语音波图片
    UIImageView *_imgViewReaded;    // 已读
    UILabel     *_lbTime;           // 消息时长度
    UILabel     *_lbMessageTime;    // 消息到达时间
    
    NSMutableArray *_arrayVoicePlaying; // 语音播放icon
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier HeadIcon:(NSString *)imgUrl Target:(id)target ActionTap:(SEL)actionTap ActionLong:(SEL)actionLong ActionFail:(SEL)actionFail ActionHead:(SEL)actionHead;

// 显示消息
- (void)showVoiceMessageTime:(NSInteger)length Tag:(NSInteger)tag;

// 设置状态
- (void)showStatus:(Msg_status)status;

// 播放声音的动画
- (void)startPlayVoiceWithTime:(CGFloat)lenght;

// 停止播放声音的动画
- (void)stopPlayVoice;

// 显示时间
- (void)showDate:(NSString *)time;

// 显示已读未读标记
- (void)isReaded:(NSInteger)readed;

@end
