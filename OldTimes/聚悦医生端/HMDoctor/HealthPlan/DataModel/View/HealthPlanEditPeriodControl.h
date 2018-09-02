//
//  HealthPlanEditPeriodControl.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/24.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthPlanEditPeriodControl : UIControl

@property (nonatomic, strong) UILabel* periodTypeLabel;
@property (nonatomic, strong) UIImageView* arrowImageView;

- (void) setPeriodTypeStr:(NSString*) periodTypeStr;

@end
