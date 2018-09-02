//
//  HMUserMissionTableViewCell.h
//  HMClient
//
//  Created by JasonWang on 2017/5/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//  今日任务cell

#import <UIKit/UIKit.h>
@class PlanMessionListItem;
@interface HMUserMissionTableViewCell : UITableViewCell
- (void)fillDataWithModel:(PlanMessionListItem *)model;
@end
