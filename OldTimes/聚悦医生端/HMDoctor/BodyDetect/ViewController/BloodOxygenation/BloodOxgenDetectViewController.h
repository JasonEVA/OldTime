//
//  BloodOxgenDetectViewController.h
//  HMClient
//
//  Created by lkl on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectInputViewController.h"

@interface BloodOxgenDetectViewController : DetectDeviceInputViewController

@property(nonatomic,assign) NSUInteger SpO2Value;
@property(nonatomic,assign) NSUInteger pulseRateValue;
@property(nonatomic,assign) NSUInteger piValue;

@end
