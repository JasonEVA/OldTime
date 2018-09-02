//
//  MenuImageView.m
//  launcher
//
//  Created by williamzhang on 15/12/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MenuImageView.h"
#import <UIMenuItem-CXAImageSupport/UIMenuItem+CXAImageSupport.h>
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
        UIMenuItem *emphasis = [[UIMenuItem alloc] cxa_initWithTitle:@"" action:@selector(emphasisMessage) image:[UIImage imageNamed:@"menu_Emphasis"]];
        [menuItems addObject:emphasis];
    }
    
    if (_showMenu & WZImageShowMenuCancelEmphasis) {
        UIMenuItem *cancelEmphasis = [[UIMenuItem alloc] cxa_initWithTitle:@"" action:@selector(cancelEmphasisMessage) image:[UIImage imageNamed:@"menu_cancelEmphasis"]];
        [menuItems addObject:cancelEmphasis];
    }
    
    if (_showMenu & WZImageShowMenuCopy) {
        UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:LOCAL(MESSAGE_COPY) action:@selector(copyString)];
        [menuItems addObject:copy];
    }
    
    if (_showMenu & WZImageShowMenuRecall) {
        UIMenuItem *recall = [[UIMenuItem alloc] initWithTitle:LOCAL(TO_RECALL) action:@selector(recallMessage)];
        [menuItems addObject:recall];
    }
    
    if (_showMenu & WZImageShowMenuSchedule) {
        UIMenuItem *schedule = [[UIMenuItem alloc] initWithTitle:LOCAL(TO_SCHEDULE) action:@selector(scheduleMessage)];
        [menuItems addObject:schedule];
    }
    
    if (_showMenu & WZImageShowMenuMission) {
        UIMenuItem *mission = [[UIMenuItem alloc] initWithTitle:LOCAL(TO_TASK) action:@selector(missionMessage)];
        [menuItems addObject:mission];
    }
    
    if (_showMenu & WZImageShowMenuMore) {
        UIMenuItem *more = [[UIMenuItem alloc] initWithTitle:LOCAL(APPLY_MORE) action:@selector(moreMessage)];
        [menuItems addObject:more];
    }

    // 加了新方法要在`ChatInputTextView中 相应添加转发方法
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:nil];
    [menu setMenuItems:menuItems];
    [menu update];
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

- (void)moreMessage {
    if ([self.delegate respondsToSelector:@selector(menuImageViewClickMore:)]) {
        [self.delegate menuImageViewClickMore:self];
    }
}

@end
