//
//  NewMissionTeamMemberTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/8/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//  任务服务群所有成员cell

#import <UIKit/UIKit.h>
@class ServiceGroupMemberModel;
@interface NewMissionTeamMemberTableViewCell : UITableViewCell
- (void)fillDataWithModel:(ServiceGroupMemberModel *)model;
@end
