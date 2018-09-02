//
//  HealthPlanSingleDetectTemplateDetailViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/9/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"

@interface HealthPlanSingleDetectTemplateDetailViewController : HMBasePageViewController

- (id) initWithTemplateModel:(HealthPlanSingleDetectTemplateModel*) templateModel
                 selectBlock:(HealthPlanSingleDetectSelectBlock) selectBlock;
@end
