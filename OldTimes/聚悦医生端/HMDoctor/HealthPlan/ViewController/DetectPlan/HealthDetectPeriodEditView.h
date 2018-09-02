//
//  HealthDetectPeriodEditView.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthDetectPeriodEditView : UIView

@property (nonatomic, strong) UITextField* periodValueTextField;
@property (nonatomic, strong) UIControl* periodTypeControl;

- (void) setHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) model;
- (void) setPeriodTypeString:(NSString*) typeString;
- (void) setAlertTimesCount:(NSInteger) count;
@end
