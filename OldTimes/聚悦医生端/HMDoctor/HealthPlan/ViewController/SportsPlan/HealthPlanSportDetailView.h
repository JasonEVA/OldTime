//
//  HealthPlanSportDetailView.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/29.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthPlanSportDetailView : UIView

@end

@interface HealthPlanSportTimeControl : UIControl

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* timeLabel;
@property (nonatomic, strong) UIImageView* arrowImageView;

- (void) setHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) criteriaModel;
@end

//运动强度
@interface HealthPlanSportStrengthControl : UIControl

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* strengthLabel;
@property (nonatomic, strong) UIImageView* arrowImageView;

- (void) setHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) criteriaModel;
@end

@interface HealthPlanSportTypesControl : UIControl

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* typesLabel;
@property (nonatomic, strong) UIImageView* arrowImageView;


@end

