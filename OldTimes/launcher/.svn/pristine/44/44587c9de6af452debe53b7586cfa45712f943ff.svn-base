//
//  ChatLeftVoiceTableViewCell.h
//  Titans
//
//  Created by Andrew Shen on 14-9-23.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  左边语音聊天Cell

#import <UIKit/UIKit.h>

@interface ChatLeftVoiceTableViewCell : UITableViewCell
{
    UIImageView *_imgViewHeadIcon;          // 头像
    UIImageView *_imgViewBubble;            // 气泡
    UIImageView *_imgViewVoice;             // 语音波图片
    UILabel     *_lbTime;                   // 消息时间显示
    UILabel     *_lbMessageTime;            // 消息到达时间
    
    UIImageView *_imgViewUnread;            // 未读圆圈
    
    NSMutableArray *_arrayVoicePlaying;     // 语音播放icon
    UILabel     *_lbName;           // 姓名
    UIImageView *_imgEmphasis;      // 重点标记标志
}

// 设置姓名
- (void)setRealName:(NSString *)name hidden:(BOOL)hidden;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier Target:(id)target Action:(SEL)action ActionHead:(SEL)actionHead longPress:(SEL)longPress;

// 显示音频时长
- (void)showVoiceMessageTime:(NSInteger)length Tag:(NSInteger)tag UnreadMark:(BOOL)unread;

// 播放声音的动画
- (void)startPlayVoiceWithTime:(CGFloat)lenght;

// 停止播放声音的动画
- (void)stopPlayVoice;

// 设置头像
- (void)setHeadIconWithUrl:(NSString *)imgUrl;

// 显示时间
- (void)showDate:(NSString *)time;

//设置重点标志(是否展示)
- (void)setEmphasisIsShow:(BOOL)IsShow;


@end
