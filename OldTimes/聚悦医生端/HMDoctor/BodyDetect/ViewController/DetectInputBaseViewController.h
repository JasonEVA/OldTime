//
//  DetectInputBaseViewController.h
//  HMDoctor
//
//  Created by lkl on 2017/8/9.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "DetectInputViewController.h"

@interface DetectInputBaseViewController : DetectInputViewController

@property(nonatomic, strong) UIScrollView  *scrollView;
@property(nonatomic, strong) UIView  *comPickerView;
@property (nonatomic, strong) DeviceTestTimeControl *testTimeControl;
@property (nonatomic, strong) UIButton *saveButton;
@property(nonatomic, strong) NSDate  *testDate;

- (void)checkForOnce;
- (void)createAlertFrame:(UIView *)view;
@end
