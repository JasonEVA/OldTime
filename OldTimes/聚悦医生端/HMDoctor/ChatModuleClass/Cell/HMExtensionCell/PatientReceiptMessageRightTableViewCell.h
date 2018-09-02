//
//  PatientReceiptMessageRightTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2017/8/3.
//  Copyright © 2017年 yinquan. All rights reserved.
//  回执消息右侧cell（类似纯文本）

#import "ChatRightBaseTableViewCell.h"
@class MessageBaseModel;
@class LinkLabel;
@interface PatientReceiptMessageRightTableViewCell : ChatRightBaseTableViewCell
@property (nonatomic, readonly) LinkLabel *messageLabel;

// 显示消息
- (void)showTextMessage:(MessageBaseModel *)message;

@end
