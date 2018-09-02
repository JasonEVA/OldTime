//
//  HealthPlanSportsStrengthPickerViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/29.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HealthPlanSportsStrengthPickHandle)(NSString* exerciseIntensity);

@interface HealthPlanSportsStrengthPickerViewController : UIViewController

+ (void) showWithExerciseIntensity:(NSString*) exerciseIntensity
                        pickHandle:(HealthPlanSportsStrengthPickHandle) pickHandle;
@end
