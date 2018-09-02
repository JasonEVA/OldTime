//
//  HealthDetectTargetView.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthDetectTargetView.h"

@interface HealthDetectTargetView ()

@property (nonatomic, strong) UILabel* kpiNameLabel;
@property (nonatomic, strong) UILabel* unitLabel;
@property (nonatomic, strong) UILabel* symbolLabel;

@end

@implementation HealthDetectTargetView

- (id) init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self layoutElemnets];
        [self showBottomLine];
    }
    return self;
}

- (void) setHealthDetectTarget:(HealthDetectPlanTargetModel*) targetModel
{
    [self.kpiNameLabel setText:targetModel.kpiName];
    [self.unitLabel setText:targetModel.unit];
    
    [self.targetValueTextField setText:targetModel.targetValue];
    [self.targetMaxValueTextField setText:targetModel.targetMaxValue];
}

- (void) layoutElemnets
{
    [self.kpiNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(12.5);
    }];
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.kpiNameLabel);
        make.left.equalTo(self.kpiNameLabel.mas_right);
    }];
    
    [self.targetMaxValueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(85, 30));
        make.right.equalTo(self).offset(-12.5);
        make.centerY.equalTo(self);
    }];
    
    [self.symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.targetMaxValueTextField.mas_left).offset(-3);
        make.centerY.equalTo(self);
    }];
    
    [self.targetValueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(85, 30));
        make.right.equalTo(self.symbolLabel.mas_left).offset(-3);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - settingAndGetting
- (UILabel*) kpiNameLabel
{
    if (!_kpiNameLabel) {
        _kpiNameLabel = [[UILabel alloc] init];
        [self addSubview:_kpiNameLabel];
        
        [_kpiNameLabel setFont:[UIFont systemFontOfSize:15]];
        [_kpiNameLabel setTextColor:[UIColor commonTextColor]];
    }
    return _kpiNameLabel;
}

- (UILabel*) unitLabel
{
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        [self addSubview:_unitLabel];
        
        [_unitLabel setFont:[UIFont systemFontOfSize:12]];
        [_unitLabel setTextColor:[UIColor commonGrayTextColor]];
    }
    return _unitLabel;
}

- (UITextField*) targetValueTextField
{
    if (!_targetValueTextField) {
        _targetValueTextField = [[UITextField alloc] init];
        [self addSubview:_targetValueTextField];
        [_targetValueTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [_targetValueTextField setKeyboardType:UIKeyboardTypeDecimalPad];
        [_targetValueTextField setFont:[UIFont systemFontOfSize:14]];
        [_targetValueTextField setTextColor:[UIColor commonTextColor]];
        [_targetValueTextField setTextAlignment:NSTextAlignmentCenter];
    }
    
    return _targetValueTextField;
}

- (UILabel*) symbolLabel
{
    if (!_symbolLabel) {
        _symbolLabel = [[UILabel alloc] init];
        [self addSubview:_symbolLabel];
        
        [_symbolLabel setFont:[UIFont systemFontOfSize:15]];
        [_symbolLabel setTextColor:[UIColor commonTextColor]];
        [_symbolLabel setText:@"-"];
    }
    return _symbolLabel;
}

- (UITextField*) targetMaxValueTextField
{
    if (!_targetMaxValueTextField) {
        _targetMaxValueTextField = [[UITextField alloc] init];
        [self addSubview:_targetMaxValueTextField];
        [_targetMaxValueTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [_targetMaxValueTextField setKeyboardType:UIKeyboardTypeDecimalPad];
        [_targetMaxValueTextField setFont:[UIFont systemFontOfSize:14]];
        [_targetMaxValueTextField setTextColor:[UIColor commonTextColor]];
        [_targetMaxValueTextField setTextAlignment:NSTextAlignmentCenter];
    }
    
    return _targetMaxValueTextField;
}

@end
