//
//  HealthPlanSportTemplateDetailViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/29.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"

@interface HealthPlanSportTemplateDetailViewController : HMBasePageViewController

- (id) initWithHealthPlanTemplateModel:(HealthPlanTemplateModel*) templateModel
                          selectHandle:(HealthPlanSubTemplateSelectHandle) selectHandle;

@end
