//
//  NewChatRightTextTableViewCell.h
//  launcher
//
//  Created by Lars Chen on 15/9/25.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatRightBaseTableViewCell.h"

@class MessageBaseModel;
@class LinkLabel;

@interface NewChatRightTextTableViewCell : ChatRightBaseTableViewCell

@property (nonatomic, readonly) LinkLabel *messageLabel;

// 显示消息
- (void)showTextMessage:(MessageBaseModel *)message;

@end
