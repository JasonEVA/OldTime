//
//  HealthPlanInvalidView.m
//  HMDoctor
//
//  Created by yinquan on 2017/9/14.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanInvalidView.h"

@interface HealthPlanInvalidView ()

@property (nonatomic, strong) UILabel* invalidLabel;


@end

@implementation HealthPlanInvalidView

- (id) init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor commonBackgroundColor]];
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.invalidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(64);
    }];
}

#pragma mark - settingAndGetting
- (void) setHasHealthyPlan:(BOOL)hasHealthyPlan
{
    _hasHealthyPlan = hasHealthyPlan;
    if (!_hasHealthyPlan) {
        [self.invalidLabel setText:@"服务中不含健康计划"];
    }
}

- (void) setInService:(BOOL)inService
{
    _inService = inService;
    if (!_inService) {
        [self.invalidLabel setText:@"计划相关的套餐服务已过期"];
    }
}

- (UILabel*) invalidLabel
{
    if (!_invalidLabel) {
        _invalidLabel = [[UILabel alloc] init];
        [self addSubview:_invalidLabel];
        
        [_invalidLabel setTextColor:[UIColor commonDarkGrayTextColor]];
        [_invalidLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _invalidLabel;
}
@end
