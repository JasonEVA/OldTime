//
//  NewChatLeftVoiceTableViewCell.h
//  launcher
//
//  Created by Lars Chen on 15/9/28.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatLeftBaseTableViewCell.h"

@interface NewChatLeftVoiceTableViewCell : ChatLeftBaseTableViewCell

// 显示音频时长
- (void)showVoiceMessageTime:(NSInteger)length unreadMark:(BOOL)unread;

// 播放声音的动画
- (void)startPlayVoiceWithTime:(CGFloat)lenght;

// 停止播放声音的动画
- (void)stopPlayVoice;


@end
