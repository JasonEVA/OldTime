//
//  HealthFillFormTemplateListViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/24.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"

typedef void(^HealthPlanFillFormTemplateSelectHandle)(HealthPlanFillFormTemplateModel* model);

@interface HealthFillFormTemplateListViewController : HMBasePageViewController

- (id) initWithCode:(NSString*) code handle:(HealthPlanFillFormTemplateSelectHandle) handle;

@end
