//
//  ChatInputTextView.m
//  launcher
//
//  Created by williamzhang on 16/2/16.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatInputTextView.h"
#import "MenuImageView.h"

@implementation ChatInputTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(nullable NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        _canPerformNormalMenu = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerDidHide) name:UIMenuControllerDidHideMenuNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.canPerformNormalMenu) {
        return [super canPerformAction:action withSender:sender];
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if (action == @selector(emphasisMessage) ||
        action == @selector(cancelEmphasisMessage) ||
        action == @selector(copyString) ||
        action == @selector(recallMessage) ||
        action == @selector(scheduleMessage) ||
        action == @selector(missionMessage) ||
        action == @selector(forwardMessage)) {
        return YES;
    }
#pragma clang diagnostic pop
    return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if (aSelector == @selector(emphasisMessage) ||
        aSelector == @selector(cancelEmphasisMessage) ||
        aSelector == @selector(copyString) ||
        aSelector == @selector(recallMessage) ||
        aSelector == @selector(scheduleMessage) ||
        aSelector == @selector(missionMessage) ||
        aSelector == @selector(forwardMessage)) {
        // 消息转发 方法来自于MenuImageView.m
        if (self.menuImageView) {
            return self.menuImageView;
        }
        
        return [[MenuImageView alloc] init];
    }
#pragma clang diagnostic pop
    
    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark - Notification
- (void)menuControllerDidHide {
    [[UIMenuController sharedMenuController] setMenuItems:nil];
    self.canPerformNormalMenu = YES;
}

@end
