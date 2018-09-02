//
//  HealthPlanSportTimePickerViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/29.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HealthPlanSportTimePickHandle)(NSString* sportTime);

@interface HealthPlanSportTimePickerViewController : UIViewController

+ (void) showWithSportTime:(NSString*) sportTime
                pickHandle:(HealthPlanSportTimePickHandle) pickHandle;

@end
