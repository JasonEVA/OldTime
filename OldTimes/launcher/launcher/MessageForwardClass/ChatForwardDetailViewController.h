//
//  ChatForwardDetailViewController.h
//  launcher
//
//  Created by williamzhang on 16/4/5.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  消息转发详情界面

#import "BaseViewController.h"
#import <MintcodeIM/MintcodeIM.h>

@interface ChatForwardDetailViewController : BaseViewController

- (instancetype)initWithForwardMessage:(MessageBaseModel *)forwardMessage;

@end
