//
//  HealthCenterPlanTaskTableViewCell.h
//  HMClient
//
//  Created by Andrew Shen on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//  健康中心计划任务cell

#import <UIKit/UIKit.h>
#import "PlanMessionListItem.h"

@interface HealthCenterPlanTaskTableViewCell : UITableViewCell

- (void) setPlanMession:(PlanMessionListItem*) plan;
@end
