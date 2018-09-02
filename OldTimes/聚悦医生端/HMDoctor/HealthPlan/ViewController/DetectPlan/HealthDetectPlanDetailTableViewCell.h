//
//  HealthDetectPlanDetailTableViewCell.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HealthDetectPlanTableIndex) {
    HealthDetectPlan_TargetIndex,   //目标值
    HealthDetectPlan_PeriodIndex,   //检测频率
    HealthDetectPlan_WarningBaseIndex,
};


@interface HealthDetectPlanDetailTableViewCell : UITableViewCell

- (void) setName:(NSString*) name value:(NSString*) value;

@end
