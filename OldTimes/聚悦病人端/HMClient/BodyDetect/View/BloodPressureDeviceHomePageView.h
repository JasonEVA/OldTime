//
//  BloodPressureDeviceHomePageView.h
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodPressureDeviceHomePageView : UIView

@property (nonatomic, strong) UIButton *useGuideBtn;
@property (nonatomic, strong) UIButton *startButton;

- (void)setDeviceImg:(NSString *)aImage;

- (void)setRemindContent:(NSString *)content;

//手机蓝牙已打开，作连接动画
- (void)startBluetoothConnectAnimationPlay;
@end
