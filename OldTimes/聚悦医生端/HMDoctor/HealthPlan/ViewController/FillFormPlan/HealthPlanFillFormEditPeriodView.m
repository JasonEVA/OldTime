//
//  HealthPlanFillFormEditPeriodView.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/24.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanFillFormEditPeriodView.h"


@interface HealthPlanFillFormEditPeriodView ()


@property (nonatomic, strong) UILabel* headerLabel;

@property (nonatomic, strong) UILabel* timesLable;

@end

@implementation HealthPlanFillFormEditPeriodView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self showBottomLine];
        [self layoutElemnets];
    }
    return self;
}

- (void) layoutElemnets
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(12.5);
    }];
    
    [self.timesLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-12.5);
    }];
    
    [self.periodTypeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.timesLable.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    [self.periodValueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.periodTypeControl.mas_left).offset(-5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.periodValueTextField.mas_left).offset(-5);
    }];
     
}



#pragma mark settingAndGetting
- (UILabel*) titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_titleLabel setTextColor:[UIColor commonTextColor]];
    }
    return _titleLabel;
}

- (UILabel*) headerLabel
{
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] init];
        [self addSubview:_headerLabel];
        [_headerLabel setText:@"每"];
        [_headerLabel setFont:[UIFont systemFontOfSize:15]];
        [_headerLabel setTextColor:[UIColor commonGrayTextColor]];
    }
    return _headerLabel;
}

- (UITextField*) periodValueTextField
{
    if (!_periodValueTextField) {
        _periodValueTextField = [[UITextField alloc] init];
        [self addSubview:_periodValueTextField];
        
        [_periodValueTextField setFont:[UIFont systemFontOfSize:15]];
        [_periodValueTextField setTextColor:[UIColor commonTextColor]];

        [_periodValueTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [_periodValueTextField setKeyboardType:UIKeyboardTypeNumberPad];
        
        [_periodValueTextField setTextAlignment:NSTextAlignmentCenter];
    }
    
    return _periodValueTextField;
}

- (UIControl*) periodTypeControl
{
    if (!_periodTypeControl) {
        _periodTypeControl = [[HealthPlanEditPeriodControl alloc] init];
        [self addSubview:_periodTypeControl];
        
        _periodTypeControl.layer.cornerRadius = 3;
        _periodTypeControl.layer.borderWidth = 0.5;
        _periodTypeControl.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        _periodTypeControl.layer.masksToBounds = YES;
    }
    return _periodTypeControl;
}

- (UILabel*) timesLable
{
    if (!_timesLable) {
        _timesLable = [[UILabel alloc] init];
        [self addSubview:_timesLable];
        [_timesLable setText:@"1次"];
        [_timesLable setFont:[UIFont systemFontOfSize:15]];
        [_timesLable setTextColor:[UIColor commonGrayTextColor]];
    }
    return _timesLable;
}

@end
