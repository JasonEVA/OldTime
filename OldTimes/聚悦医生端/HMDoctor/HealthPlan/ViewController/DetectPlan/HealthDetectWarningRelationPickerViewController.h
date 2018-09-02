//
//  HealthDetectWarningRelationPickerViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/23.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^HealthDetectWarningRelationPickHandle)(NSString* relation);

@interface HealthDetectWarningRelationPickerViewController : UIViewController

+ (void) showWithHandle:(HealthDetectWarningRelationPickHandle) handle;

@end
