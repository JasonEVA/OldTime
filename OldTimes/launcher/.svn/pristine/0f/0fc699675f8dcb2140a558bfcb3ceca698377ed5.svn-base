//
//  ChatBubbleConfig.m
//  launcher
//
//  Created by williamzhang on 16/2/24.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatBubbleConfig.h"
#import "UIColor+Hex.h"

@implementation ChatBubbleConfig
{
    ChatSingleBubbleConfig *_leftConfig;
    ChatSingleBubbleConfig *_rightConfig;
}

+ (instancetype)share {
    static ChatBubbleConfig *share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[ChatBubbleConfig alloc] init];
    });
    
    return share;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _leftConfig = [ChatSingleBubbleConfig defaultLeftConfigure];
        _rightConfig = [ChatSingleBubbleConfig defaultRightConfigure];
    }
    return self;
}

- (ChatSingleBubbleConfig *)getBubbleConfigFromLeft:(BOOL)left {
    return left ? _leftConfig : _rightConfig;
}

@end


@implementation ChatSingleBubbleConfig

+ (instancetype)defaultLeftConfigure {
    ChatSingleBubbleConfig *configure = [[ChatSingleBubbleConfig alloc] init];
    
    configure.textColor = [UIColor blackColor];
    configure.linkColor = [UIColor blackColor];

    configure.atUserColor = [UIColor whiteColor];
    configure.atUserBackgroudColor = [UIColor mtc_colorWithW:97];
    
    configure.textBackgroundColor = [UIColor mtc_colorWithW:204];
    
    configure.attachSizeColor = [UIColor mtc_colorWithHex:0x999999];
    
    configure.timeColor = [UIColor minorFontColor];
    
    configure.forwardTitleColor = [UIColor blackColor];
    configure.forwardMessageColor = [UIColor mediumFontColor];
    
    return configure;
}

+ (instancetype)defaultRightConfigure {
    ChatSingleBubbleConfig *configure = [[ChatSingleBubbleConfig alloc] init];
    
    configure.textColor = [UIColor whiteColor];
    configure.linkColor = [UIColor whiteColor];
    
    configure.readedColor = [UIColor minorFontColor];
    
    configure.atUserColor = [UIColor themeBlue];
    configure.atUserBackgroudColor = [UIColor whiteColor];
    
    configure.textBackgroundColor = [UIColor themeBlue];
    
    configure.attachSizeColor = [UIColor mtc_colorWithHex:0xffffff];
    
    configure.timeColor = [UIColor minorFontColor];
    
    configure.forwardTitleColor = [UIColor blackColor];
    configure.forwardMessageColor = [UIColor mediumFontColor];
    
    return configure;
}

@end