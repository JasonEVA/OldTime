//
//  DeviceSelectTestTimeView.h
//  HMClient
//
//  Created by lkl on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceSelectTestTimeView : UIView

@property (nonatomic, copy) void(^testTimeBlock)(NSString *testTime);
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmDateBtn;
@property (nonatomic, assign) BOOL pickerMode;

@end
