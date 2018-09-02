//
//  HealthDetectAlertTimePickerViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertTimePickerBlock)(NSString* pickTime);

@interface HealthDetectAlertTimePickerViewController : UIViewController

+ (void) showWithPickerBlock:(AlertTimePickerBlock) pickBlock;
@end
