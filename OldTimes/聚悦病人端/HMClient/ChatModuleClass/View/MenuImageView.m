//
//  MenuImageView.m
//  launcher
//
//  Created by williamzhang on 15/12/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MenuImageView.h"
#import "MyDefine.h"

@interface MenuImageView ()

@end

@implementation MenuImageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self attachTapHandler];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder {
    if ([self.delegate respondsToSelector:@selector(menuImageViewCanBecomeFirstResponder:)]) {
        return [self.delegate menuImageViewCanBecomeFirstResponder:self];
    }
    return YES;
}

- (void)attachTapHandler {
    self.userInteractionEnabled = YES; // 用户交互总开关
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    touch.numberOfTapsRequired = 1;
    [self addGestureRecognizer:touch];
    
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    press.minimumPressDuration = 0.5;
    [self addGestureRecognizer:press];
}

- (void)handleTap:(UIGestureRecognizer *)recognizer {
    if ([self.delegate respondsToSelector:@selector(menuImageViewTap:)]) {
        [self.delegate menuImageViewTap:self];
    }
}

- (void)longPress:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self showTheMenu];
    }
}

- (void)showTheMenu {
    if ([self canBecomeFirstResponder]) {
        [self becomeFirstResponder];
    }
    
    NSMutableArray *menuItems = [NSMutableArray array];
    
    if (_showMenu & WZImageShowMenuEmphasis) {
        UIMenuItem *emphasis = [[UIMenuItem alloc] initWithTitle:@"标记重点" action:@selector(emphasisMessage)];
        [menuItems addObject:emphasis];
    }
    
    if (_showMenu & WZImageShowMenuCancelEmphasis) {
        UIMenuItem *cancelEmphasis = [[UIMenuItem alloc] initWithTitle:@"取消重点" action:@selector(cancelEmphasisMessage)];
        [menuItems addObject:cancelEmphasis];
    }
    
    if (_showMenu & WZImageShowMenuCopy) {
        UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyString)];
        [menuItems addObject:copy];
    }
    
    if (_showMenu & WZImageShowMenuRecall) {
        if ([self p_canRecallMessage]) {
            UIMenuItem *recall = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(recallMessage)];
            [menuItems addObject:recall];
        }
    }
    
    if (_showMenu & WZImageShowMenuSchedule) {
        UIMenuItem *schedule = [[UIMenuItem alloc] initWithTitle:@"转为日程" action:@selector(scheduleMessage)];
        [menuItems addObject:schedule];
    }
    
    if (_showMenu & WZImageShowMenuMission) {
        UIMenuItem *mission = [[UIMenuItem alloc] initWithTitle:@"转为任务" action:@selector(missionMessage)];
        [menuItems addObject:mission];
    }
    
    if (_showMenu & WZImageShowMenuForward) {
        UIMenuItem *mission = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(forwardMessage)];
        [menuItems addObject:mission];
    }

    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:nil];
    [menu setMenuItems:menuItems];
    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark - Menu Selector
- (void)emphasisMessage {
    // 标记重点
    if ([self.delegate respondsToSelector:@selector(menuImageViewClickEmphasis:)]) {
        [self.delegate menuImageViewClickEmphasis:self];
    }
}

- (void)cancelEmphasisMessage {
    if ([self.delegate respondsToSelector:@selector(menuImageViewClickCancelEmphasis:)]) {
        [self.delegate menuImageViewClickCancelEmphasis:self];
    }
}

- (void)copyString {
    // 复制
    if ([self.delegate respondsToSelector:@selector(menuImageViewClickCopy:)]) {
        [self.delegate menuImageViewClickCopy:self];
    }
}

- (void)recallMessage {
    // 撤回
    if ([self.delegate respondsToSelector:@selector(menuImageViewClickRecall:)]) {
        [self.delegate menuImageViewClickRecall:self];
    }
}

- (void)scheduleMessage {
    // 转日程
    if ([self.delegate respondsToSelector:@selector(menuImageViewClickSchedule:)]) {
        [self.delegate menuImageViewClickSchedule:self];
    }
}

- (void)missionMessage {
    // 转任务
    if ([self.delegate respondsToSelector:@selector(menuImageViewClickMission:)]) {
        [self.delegate menuImageViewClickMission:self];
    }
}

- (void)forwardMessage {
    // 转发
    if ([self.delegate respondsToSelector:@selector(menuImageViewClickForward:)]) {
        [self.delegate menuImageViewClickForward:self];
    }

}

#pragma mark - Private Method

- (BOOL)p_canRecallMessage {
    if ([self.delegate respondsToSelector:@selector(menuImageViewCanRecallMessage:)]) {
        return [self.delegate menuImageViewCanRecallMessage:self];
    }
    return YES;
}

@end
