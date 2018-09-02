//
//  MenuImageView.h
//  launcher
//
//  Created by williamzhang on 15/12/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  menu弹出设定

#import <UIKit/UIKit.h>

@class MenuImageView;

typedef NS_ENUM(NSUInteger, WZImageShowMenu) {
    WZImageShowMenuEmphasis       = 1,          // 标记重点
    WZImageShowMenuCancelEmphasis = 1 << 1,     // 取消重点
    WZImageShowMenuCopy           = 1 << 2,     // 复制
    WZImageShowMenuRecall         = 1 << 3,     // 撤回
    WZImageShowMenuSchedule       = 1 << 4,     // 转为日程
    WZImageShowMenuMission        = 1 << 5,      // 转为任务
    WZImageShowMenuForward        = 1 << 6      // 转发

};

@protocol MenuImageViewDelegate <NSObject>

- (BOOL)menuImageViewCanBecomeFirstResponder:(MenuImageView *)imageView;

// 消息撤回条件
- (BOOL)menuImageViewCanRecallMessage:(MenuImageView *)imageView;

@optional
- (void)menuImageViewClickEmphasis:(MenuImageView *)imageView;
- (void)menuImageViewClickCancelEmphasis:(MenuImageView *)imageView;
- (void)menuImageViewClickCopy:(MenuImageView *)imageView;
- (void)menuImageViewClickRecall:(MenuImageView *)imageView;
- (void)menuImageViewClickSchedule:(MenuImageView *)imageView;
- (void)menuImageViewClickMission:(MenuImageView *)imageView;

- (void)menuImageViewTap:(MenuImageView *)imageView;

- (void)menuImageViewClickForward:(MenuImageView *)imageView;

@end

@interface MenuImageView : UIImageView

@property (nonatomic, weak) id<MenuImageViewDelegate> delegate;
@property (nonatomic, assign) WZImageShowMenu showMenu;

- (void)showTheMenu;

@end
