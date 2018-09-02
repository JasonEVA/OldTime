//
//  HealthPlanMentailityPeriodPickerViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/28.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HealthPlanMentailityPeriodPickHandle)(NSString* periodValue, NSString* periodType);

@interface HealthPlanMentailityPeriodPickerViewController : UIViewController

+ (void) showWithPeriodType:(NSString*) type
                periodValue:(NSString*) periodValue
                     handle:(HealthPlanMentailityPeriodPickHandle) pickHandle;
@end
