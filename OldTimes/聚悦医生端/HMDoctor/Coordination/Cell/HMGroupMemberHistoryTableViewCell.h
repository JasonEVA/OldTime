//
//  HMGroupMemberHistoryTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2017/4/11.
//  Copyright © 2017年 yinquan. All rights reserved.
//  群成员历史消息 cell

#import <UIKit/UIKit.h>
@class UserProfileModel;
@interface HMGroupMemberHistoryTableViewCell : UITableViewCell
- (void)fillDataWithProfileModel:(UserProfileModel *)profileModel;

@end
