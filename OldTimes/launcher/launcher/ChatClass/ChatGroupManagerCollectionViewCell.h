//
//  ChatGroupmanagerCollectionViewCell.h
//  launcher
//
//  Created by Andrew Shen on 15/9/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  群聊设置collectioncell

#import <UIKit/UIKit.h>
#import "ChatManagerAvatarView.h"

@class UserProfileModel;
typedef void (^deletePersonWithIndex)(NSIndexPath *cellIndexPath);

@interface ChatGroupManagerCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)  NSIndexPath  *indexPath; // <##>

- (instancetype)initWithFrame:(CGRect)frame;
/**
 *  是否编辑头像
 *
 *  @param edit 是否编辑
 */
- (void)avatarEdit:(BOOL)edit;

// 设置数据
- (void)setAvatarData:(UserProfileModel *)model;

// 监听删除事件
- (void)deserveDeleteEvent:(deletePersonWithIndex)deletePerson;
@end
