//
//  WorkCircleMembersTableViewCell.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserProfileModel;

extern CGFloat const itemWidth;
extern CGFloat const itemHeight;

@protocol WorkCircleMembersTableViewCellDelegate <NSObject>

- (void)workCircleMembersTableViewCellDelegateCallBack_memberClickedWithData:(id)memberData indexPath:(NSIndexPath *)indexPath;

- (void)workCircleMembersTableViewCellDelegateCallBack_addMemberClicked;


@end
@interface WorkCircleMembersTableViewCell : UITableViewCell

@property (nonatomic, weak)  id<WorkCircleMembersTableViewCellDelegate>  delegate; // <##>

// 设置人员信息
- (void)configCellData:(NSArray<UserProfileModel *> *)memberList;
@end
