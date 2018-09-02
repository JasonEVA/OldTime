//
//  NewChatLeftTextTableViewCell.h
//  launcher
//
//  Created by Lars Chen on 15/9/28.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatLeftBaseTableViewCell.h"

@class LinkLabel;
@class MessageBaseModel;

@interface NewChatLeftTextTableViewCell : ChatLeftBaseTableViewCell

@property (nonatomic, readonly) LinkLabel *messageLabel;

- (void)showTextMessage:(MessageBaseModel *)message;

@end
