//
//  HealthDetectWaringTypePickerViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/22.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HealthDetectWaringTypePick)(NSInteger type);

@interface HealthDetectWaringTypePickerViewController : UIViewController

+ (void) showWithDefaultWarningType:(HealthDetectWarningType) defaultType
                          PickBlock:(HealthDetectWaringTypePick) pickBlock;
@end
