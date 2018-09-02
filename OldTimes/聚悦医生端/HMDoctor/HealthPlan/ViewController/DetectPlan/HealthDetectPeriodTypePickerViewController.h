//
//  HealthDetectPeriodTypePickerViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PeriodTypePickerBlock)(NSString* pickertype);

@interface HealthDetectPeriodTypePickerViewController : UIViewController

+ (void) showWithPeriodTypeStr:(NSString*) typeStr
         PeriodTypePickerBlock:(PeriodTypePickerBlock) pickBlock;
@end
