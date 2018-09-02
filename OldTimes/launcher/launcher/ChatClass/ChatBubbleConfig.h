//
//  ChatBubbleConfig.h
//  launcher
//
//  Created by williamzhang on 16/2/24.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  聊天气泡配置

#import <UIKit/UIKit.h>

#ifndef CHAT_SHOWTIME
#define CHAT_SHOWTIME 0
#endif

#define ChatBubbleLeftConfigShare [[ChatBubbleConfig share] getBubbleConfigFromLeft:YES]
#define ChatBubbleRightConfigShare [[ChatBubbleConfig share] getBubbleConfigFromLeft:NO]

@class ChatSingleBubbleConfig;
@interface ChatBubbleConfig : NSObject

+ (instancetype)share;
- (ChatSingleBubbleConfig *)getBubbleConfigFromLeft:(BOOL)left;

@end

@interface ChatSingleBubbleConfig : NSObject

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *linkColor;

@property (nonatomic, strong) UIColor *readedColor;

@property (nonatomic, strong) UIColor *attachSizeColor;

@property (nonatomic, strong) UIColor *atUserColor;
@property (nonatomic, strong) UIColor *atUserBackgroudColor;

@property (nonatomic, strong) UIColor *textBackgroundColor;

@property (nonatomic, strong) UIColor *timeColor;

@property (nonatomic, strong) UIColor *forwardTitleColor;
@property (nonatomic, strong) UIColor *forwardMessageColor;

+ (instancetype)defaultLeftConfigure;
+ (instancetype)defaultRightConfigure;

@end