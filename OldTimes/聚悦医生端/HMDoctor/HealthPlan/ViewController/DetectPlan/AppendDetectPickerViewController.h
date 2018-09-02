//
//  AppendDetectPickerViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/23.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AppendDetectHandle)(DetectKPIModel* model);

@interface AppendDetectPickerViewController : UIViewController

+ (void) showWithExistKpiList:(NSArray*) kpiList
                       handle:(AppendDetectHandle) handle;
@end
