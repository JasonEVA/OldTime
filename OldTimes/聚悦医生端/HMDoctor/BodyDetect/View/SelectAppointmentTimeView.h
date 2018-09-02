//
//  SelectAppointmentTimeView.h
//  HMDoctor
//
//  Created by lkl on 16/7/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectAppointmentTimeView : UIView

@property (nonatomic, copy) void(^testTimeBlock)(NSString *testTime);
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmDateBtn;
@property (nonatomic, assign) BOOL pickerMode;

@end
