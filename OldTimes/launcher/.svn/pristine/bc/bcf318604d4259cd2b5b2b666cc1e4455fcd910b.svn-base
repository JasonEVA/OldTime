//
//  ChatGroutAvatarsTableViewCell.h
//  launcher
//
//  Created by Andrew Shen on 15/9/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const interitemSpacing; // 最小列间距
extern CGFloat const lineSpacing; // 最小行间距
extern CGFloat const collectionCellWidth; // cell 宽
extern CGFloat const collectionCellheight; // cell 高

@class UserProfileModel;
@protocol ChatGroutAvatarsTableViewCellDelegate <NSObject>

// 增加
- (void)ChatGroutAvatarsTableViewCellDelegateCallBack_addPeople;

// 删除
- (void)ChatGroutAvatarsTableViewCellDelegateCallBack_deletePeopleWithProfile:(UserProfileModel *)model;

// 点击查看那个人信息
- (void)ChatGroutAvatarsTableViewCellDelegateCallBack_personDetailClicked:(UserProfileModel *)model;

@end
@interface ChatGroutAvatarsTableViewCell : UITableViewCell

@property (nonatomic, weak)  id<ChatGroutAvatarsTableViewCellDelegate>  delegate; // <##>

/**
 *  设置头像数据
 *
 *  @param arrayPerson 数据
 *  @param isHost      是否是群主
 */
- (void)setPersonData:(NSArray *)arrayPerson isHost:(BOOL)isHost;
@end
