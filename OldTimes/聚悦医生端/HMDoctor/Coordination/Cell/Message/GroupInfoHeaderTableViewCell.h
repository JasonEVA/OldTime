//
//  GroupInfoHeaderTableViewCell.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//  群名片头部cell

#import <UIKit/UIKit.h>
#import <MintcodeIMKit/MintcodeIMKit.h>
@class StaffServiceInfoModel;
@protocol GroupInfoHeaderTableViewCellDelegate <NSObject>

- (void)groupInfoHeaderTableViewCellDelegateCallBack_doctorClickedWithIndex:(NSInteger)index;

@end
@interface GroupInfoHeaderTableViewCell : UITableViewCell
@property (nonatomic, weak)  id<GroupInfoHeaderTableViewCellDelegate>  delegate; // <##>
- (void)configDataWith:(UserProfileModel *)model;
- (void)setSeviceModel:(StaffServiceInfoModel *)seviceModel;

@end
