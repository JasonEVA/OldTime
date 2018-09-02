//
//  BloodSugarDeviceHomePageView.h
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodSugarDeviceHomePageView : UIView

@property(nonatomic,strong) UIButton *measureButton;

@property (nonatomic,strong) UIControl *testPeriodControl;

@property (nonatomic,strong) UILabel *lbtestPeriod;
- (void)setDeviceImage:(NSString *)image;
- (void)setRemindContent:(NSString *)content;

- (void)setTestPeriodSelect:(NSString *)testPeriod;

@property (nonatomic, strong) UIButton *useGuideBtn;

@end
