//
//  HealthPlanMessionTableViewCell.h
//  HMDoctor
//
//  Created by yinqaun on 16/6/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthPlanMessionInfo.h"

@interface HealthPlanMessionTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, readonly) UIButton* operateButton;
@property (nonatomic, readonly) UIButton* archiveButton;

- (void) setHealthPlan:(HealthPlanMessionInfo*) healthPlan;
@end
