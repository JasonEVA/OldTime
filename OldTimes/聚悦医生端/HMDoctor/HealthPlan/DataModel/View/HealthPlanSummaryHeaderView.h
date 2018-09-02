//
//  HealthPlanSummaryHeaderView.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HealthPlanSummaryHeaderView : UIView

@property (nonatomic, strong) UIButton* templateButton; //模版选择

- (void) setHealthPlanDet:(HealthPlanDetailModel*) model;
@end
