//
//  HealthPlanTemplateSelectViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"

@interface HealthPlanTemplateSelectViewController : HMBasePageViewController

- (id) initWithTypeCode:(NSString*) typeCode selectedBlock:(HealthPlanTemplateSelectedBlock) selectedBlock;

@end
