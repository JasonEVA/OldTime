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
    configure.atUserBackgroudColor = [UIColor colorWithW:97];
    
    configure.textBackgroundColor = [UIColor colorWithW:255];
    
    configure.attachSizeColor = [UIColor colorWithHex:0x999999];
    
    configure.timeColor = [UIColor minorFontColor];
    
    return configure;
}

+ (instancetype)defaultRightConfigure {
    ChatSingleBubbleConfig *configure = [[ChatSingleBubbleConfig alloc] init];
    
    configure.textColor = [UIColor whiteColor];
    configure.linkColor = [UIColor whiteColor];
    
    configure.readedColor = [UIColor minorFontColor];
    
    configure.atUserColor = [UIColor mainThemeColor];
    configure.atUserBackgroudColor = [UIColor whiteColor];
    
    configure.textBackgroundColor = [UIColor mainThemeColor];
    
    configure.attachSizeColor = [UIColor colorWithHex:0xffffff];
    
    configure.timeColor = [UIColor minorFontColor];
    
    return configure;
}

@end