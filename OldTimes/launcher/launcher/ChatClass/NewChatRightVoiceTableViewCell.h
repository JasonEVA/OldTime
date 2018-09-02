//
//  NewChatRightVoiceTableViewCell.h
//  launcher
//
//  Created by Lars Chen on 15/9/25.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatRightBaseTableViewCell.h"

@interface NewChatRightVoiceTableViewCell : ChatRightBaseTableViewCell

// 显示消息
- (void)showVoiceMessageTime:(NSInteger)length;

// 播放声音的动画
- (void)startPlayVoiceWithTime:(CGFloat)lenght;

// 停止播放声音的动画
- (void)stopPlayVoice;

@end
