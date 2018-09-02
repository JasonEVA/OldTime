//
//  HealthDetectTargetEditViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"

@interface HealthDetectTargetEditViewController : HMBasePageViewController

- (id) initWithKpiName:(NSString*) kpiName
               kpiCode:(NSString*) kpiCode
               targets:(NSArray*) targets
       editTargetBlock:(HealthDetectPlanEditTarget) editTargetBlock;

@end
