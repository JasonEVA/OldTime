//
//  ChatBaseViewController+ChatInputViewActions.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//  输入栏事件

#import "ChatBaseViewController.h"

typedef void(^InputViewCustomAttachmentActionHandler)(ChatAttachPick_tag tag);

@interface ChatBaseViewController (ChatInputViewActions)<RMAudioManagerDelegate,ChatInputViewDelegate>

@property (nonatomic, copy, readonly)  InputViewCustomAttachmentActionHandler  attachmentActionHandler; // <##>

- (void)ats_inputViewCustomAttachmentActionResponse:(InputViewCustomAttachmentActionHandler)handler;

- (void)at_sendReceiptMsgWith:(NSString *)text;   // 发送回执消息，由子类实现

@end
