//
//  HealtDetectWarningKpiPickerViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/22.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HealtDetectWarningKpiPickerHandle)(HealthDetectWarningSubKpiModel* kpiModel);

@interface HealtDetectWarningKpiPickerViewController : UIViewController

+ (void) showWithKpiCode:(NSString*) kpiCode
              subKpiCode:(NSString*) subKpiCode
            subKpiModels:(NSArray*) subKpiModels
                  handle:(HealtDetectWarningKpiPickerHandle)handle;
@end
