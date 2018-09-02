//
//  HealthDetectPeriodEditViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"

@interface HealthDetectPeriodEditViewController : HMBasePageViewController

@property (nonatomic, strong) HealthDetectPlanEditAlertTimes alertTimesBlock;

- (id) initWithCriteriaModel:(HealthPlanDetCriteriaModel*) criteriaModel;

@end
