//
//  HealthDetectWarningEditViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/21.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"

@interface HealthDetectWarningEditViewController : HMBasePageViewController
{
    
}

@property (nonatomic, strong) HealthDetectPlanEditWarningHandle editHandle;

- (id) initWithHealthDetectPlanWarningModel:(HealthDetectPlanWarningModel*) warningModel
                                   kpiTitle:(NSString*) kpiTitle
                                    kpiCode:(NSString*) kpiCode;

@end
