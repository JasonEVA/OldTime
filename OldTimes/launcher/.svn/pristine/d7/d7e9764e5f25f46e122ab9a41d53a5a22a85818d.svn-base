//
//  ChatBottomMoreBar.h
//  launcher
//
//  Created by williamzhang on 16/3/28.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  聊天更多下部分按钮

#import <UIKit/UIKit.h>

@class ChatBottomMoreBar;

@protocol ChatBottomMoreBarDelegate <NSObject>

- (void)chatBottomMoreBar:(ChatBottomMoreBar *)bottomMoreBar clickedAtIndex:(NSUInteger)index;

@end

@interface ChatBottomMoreBar : UIView

@property (nonatomic, weak) id<ChatBottomMoreBarDelegate> delegate;

- (instancetype)initWithImages:(NSArray *)images titles:(NSArray *)titles;

//及时修改标记图标和标题
- (void)setTitleEmphsisButtonWithTitle:(NSString *)title Image:(UIImage*)image;

- (void)canTapButtons:(BOOL)canTap;

@end
