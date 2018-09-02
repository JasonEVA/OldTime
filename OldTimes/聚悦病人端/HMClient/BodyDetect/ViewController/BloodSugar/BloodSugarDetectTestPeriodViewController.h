//
//  BloodSugarDetectTestPeriodViewController.h
//  HMClient
//
//  Created by lkl on 16/5/11.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TestPeriodSelectBlock)(NSDictionary* testPeriodItem);

@interface BloodSugarDetectTestPeriodViewController : UIViewController

+ (BloodSugarDetectTestPeriodViewController*) createWithParentViewController:(UIViewController*) parentviewcontroller
                                                                    isDevice:(BOOL) isDevice
                                                                 selectblock:(TestPeriodSelectBlock)block;
@end
