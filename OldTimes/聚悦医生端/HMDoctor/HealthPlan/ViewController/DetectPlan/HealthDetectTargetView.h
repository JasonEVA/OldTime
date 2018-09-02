//
//  HealthDetectTargetView.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthDetectTargetView : UIControl

@property (nonatomic, strong) UITextField* targetValueTextField;

@property (nonatomic, strong) UITextField* targetMaxValueTextField;

- (void) setHealthDetectTarget:(HealthDetectPlanTargetModel*) targetModel;
@end
