//
//  HealthFillFormTemplateTableViewCell.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/24.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthFillFormTemplateTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton* perviewButton;

- (void) setHealthPlanTemplateModel:(HealthPlanFillFormTemplateModel*) model;

@end
