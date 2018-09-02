//
//  HealthPlanDetailPagedViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/30.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"

@interface HealthPlanDetailPagedViewController : HMBasePageViewController

- (id) initWithDetailModel:(HealthPlanDetailModel*) detailModel
              defaultIndex:(NSInteger) defaultIndex;

@end
