//
//  PatientReceiptMessageLeftTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2017/8/3.
//  Copyright © 2017年 yinquan. All rights reserved.
//  回执消息左侧cell（类似纯文本）

#import "ChatLeftBaseTableViewCell.h"

@class LinkLabel;
@class MessageBaseModel;

@interface PatientReceiptMessageLeftTableViewCell : ChatLeftBaseTableViewCell
@property (nonatomic, readonly) LinkLabel *messageLabel;

- (void)showTextMessage:(MessageBaseModel *)message;
@end
