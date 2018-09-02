//
//  NewChatLeftAttachTableViewCell.h
//  launcher
//
//  Created by Lars Chen on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  左边聊天附件Cell

#import "ChatLeftBaseTableViewCell.h"

@interface NewChatLeftAttachTableViewCell : ChatLeftBaseTableViewCell

// 显示消息
- (void)setAttachmentData:(MessageAttachmentModel *)model;

@end
