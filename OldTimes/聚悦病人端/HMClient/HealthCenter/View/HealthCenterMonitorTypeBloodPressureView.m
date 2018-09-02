//
//  HealthCenterMonitorTypeBloodPressureView.m
//  HMClient
//
//  Created by Andrew Shen on 16/5/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthCenterMonitorTypeBloodPressureView.h"

@implementation HealthCenterMonitorTypeBloodPressureView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configElements];
    }
    return self;
}

#pragma mark - Private Method
// 设置元素控件
- (void)configElements {
    
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self addSubview:self.healthLevel];
    [self addSubview:self.lbHealthLevel];
    [self addSubview:self.title];
    [self addSubview:self.value];
    [self addSubview:self.unit];
    [self addSubview:self.date];
    
    [self.healthLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.lbHealthLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.healthLevel);
        make.centerY.equalTo(self.healthLevel).offset(5);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.healthLevel.mas_right).offset(15);
        make.top.equalTo(self.healthLevel);
    }];
    [self.value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.bottom.equalTo(self.healthLevel);
    }];
    [self.unit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.value.mas_right).offset(7);
        make.bottom.equalTo(self.value);
    }];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title);
        make.right.equalTo(self).offset(-15);
    }];
}

// 设置数据
- (void)configData {
    
}

#pragma mark - Init

- (UIImageView *)healthLevel {
    if (!_healthLevel) {
        _healthLevel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_bloodpressure_level4"]];
    }
    return _healthLevel;
}

- (UILabel *)lbHealthLevel {
    if (!_lbHealthLevel) {
        _lbHealthLevel = [UILabel new];
        _lbHealthLevel.textColor = [UIColor commonOrangeColor];
        _lbHealthLevel.font = [UIFont font_28];
        _lbHealthLevel.text = @"轻度";
    }
    return _lbHealthLevel;
}

- (UILabel *)title {
    if (!_title) {
        _title = [UILabel new];
        _title.textColor = [UIColor commonGrayTextColor];
        _title.font = [UIFont font_30];
        _title.text = @"血压";
    }
    return _title;
}

- (UILabel *)value {
    if (!_value) {
        _value = [UILabel new];
        _value.textColor = [UIColor commonDarkGrayTextColor];
        _value.font = [UIFont systemFontOfSize:25];
        _value.text = @"147 / 100";
    }
    return _value;
}

- (UILabel *)unit {
    if (!_unit) {
        _unit = [UILabel new];
        _unit.textColor = [UIColor commonGrayTextColor];
        _unit.font = [UIFont font_24];
        _unit.text = @"mmHg";
    }
    return _unit;
}

- (UILabel *)date {
    if (!_date) {
        _date = [UILabel new];
        _date.textColor = [UIColor commonGrayTextColor];
        _date.font = [UIFont font_24];
        _date.text = @"5月20日 12:00";
    }
    return _date;
}

@end
