//
//  ChatManagerAvatarView.h
//  launcher
//
//  Created by Andrew Shen on 15/9/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  聊天设置页头像

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ChatGroupAvatarTag) {
    avatar_host,
    avatar_others,
    avatar_add,
    avatar_delete,
    avatar_detail,
};

@interface ChatManagerAvatarView : UIView

/**
 *  是否编辑头像
 *
 *  @param edit 是否编辑
 */
- (void)avatarEdit:(BOOL)edit;

/**
 *  设置编辑事件
 */
- (void)setEditTarget:(id)target event:(SEL)event;

// 设置头像
- (void)setAvatar:(NSString *)strAvatar;
//设置圆角大小
- (void)setAvatarHaveCorners:(float)corners;

@end
