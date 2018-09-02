//
//  HeathPlanFillFormEditViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/24.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"




@interface HeathPlanFillFormEditViewController : HMBasePageViewController

- (id) initWithHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) model
                                     code:(NSString*) code
                                   handle:(HeathPlanFillFormEditHandle) handel;

@end
