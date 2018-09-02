//
//  HealthPlanFillFormEditPeriodView.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/24.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthPlanEditPeriodControl.h"

@interface HealthPlanFillFormEditPeriodView : UIView

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UITextField* periodValueTextField;
@property (nonatomic, strong) UIControl* periodTypeControl;

@end
