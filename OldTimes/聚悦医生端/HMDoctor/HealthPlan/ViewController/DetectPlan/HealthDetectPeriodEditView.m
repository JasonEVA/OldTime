//
//  HealthDetectPeriodEditView.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthDetectPeriodEditView.h"
#import "HealthPlanEditPeriodControl.h"



@interface HealthDetectPeriodEditView ()
{
    
}
@property (nonatomic, strong) UILabel* periodTitleLabel;
@property (nonatomic, strong) UILabel* periodLable;     //每

@property (nonatomic, strong) UIView* periodView;

@property (nonatomic, strong) UILabel* periodUnitLable; //次

@end

@implementation HealthDetectPeriodEditView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self showBottomLine];
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.periodTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12.5);
        make.centerY.equalTo(self);
    }];
    
    [self.periodUnitLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-12.5);
    }];
    
    [self.periodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(156, 30));
        make.centerY.equalTo(self);
        make.right.equalTo(self.periodUnitLable.mas_left).offset(-4);
    }];
    
    [self.periodLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.periodView.mas_left).offset(-4);
    }];
    
    [self.periodValueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.periodView);
    }];
    
    [self.periodTypeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.periodView);
        make.left.equalTo(self.periodValueTextField.mas_right);
        make.width.equalTo(self.periodValueTextField);
    }];
}

- (void) setHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) model
{
    NSString* periodString = [NSString stringWithFormat:@"%ld次", model.alertTimes.count];
    [self.periodUnitLable setText:periodString];
    [self.periodValueTextField setText:model.periodValue];
    
    HealthPlanEditPeriodControl* periodTypeControl = (HealthPlanEditPeriodControl*)self.periodTypeControl;
    [periodTypeControl setPeriodTypeStr:model.periodType];
}

- (void) setPeriodTypeString:(NSString*) typeString
{
    HealthPlanEditPeriodControl* periodTypeControl = (HealthPlanEditPeriodControl*)self.periodTypeControl;
    [periodTypeControl setPeriodTypeStr:typeString];
}

- (void) setAlertTimesCount:(NSInteger) count
{
    NSString* periodString = [NSString stringWithFormat:@"%ld次", count];
    [self.periodUnitLable setText:periodString];
}

#pragma mark - settingAndGetting
- (UILabel*) periodTitleLabel
{
    if (!_periodTitleLabel) {
        _periodTitleLabel = [[UILabel alloc] init];
        [self addSubview:_periodTitleLabel];
        [_periodTitleLabel setTextColor:[UIColor commonTextColor]];
        [_periodTitleLabel setFont:[UIFont systemFontOfSize:15]];
        [_periodTitleLabel setText:@"测量频率"];
    }
    return _periodTitleLabel;
}

- (UILabel*) periodLable
{
    if (!_periodLable) {
        _periodLable = [[UILabel alloc] init];
        [self addSubview:_periodLable];
        [_periodLable setTextColor:[UIColor commonGrayTextColor]];
        [_periodLable setFont:[UIFont systemFontOfSize:15]];
        [_periodLable setText:@"每"];
    }
    return _periodLable;
}

- (UIView*) periodView
{
    if (!_periodView) {
        _periodView = [[UIView alloc] init];
        [self addSubview:_periodView];
        [_periodView setBackgroundColor:[UIColor whiteColor]];
        
        _periodView.layer.cornerRadius = 3;
        _periodView.layer.borderWidth = 0.5;
        _periodView.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        _periodView.layer.masksToBounds = YES;
         
    }
    return _periodView;
}

- (UITextField*) periodValueTextField
{
    if (!_periodValueTextField) {
        _periodValueTextField = [[UITextField alloc] init];
        [self.periodView addSubview:_periodValueTextField];
        
        [_periodValueTextField setTextColor:[UIColor commonTextColor]];
        [_periodValueTextField setTextAlignment:NSTextAlignmentCenter];
        [_periodValueTextField setFont:[UIFont systemFontOfSize:15]];
        [_periodValueTextField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    return _periodValueTextField;
}

- (UIControl*) periodTypeControl
{
    if (!_periodTypeControl) {
        _periodTypeControl = [[HealthPlanEditPeriodControl alloc] init];
        [self.periodView addSubview:_periodTypeControl];
        [_periodTypeControl showLeftLine];
    }
    return _periodTypeControl;
}

- (UILabel*) periodUnitLable
{
    if (!_periodUnitLable) {
        _periodUnitLable = [[UILabel alloc] init];
        [self addSubview:_periodUnitLable];
        [_periodUnitLable setTextColor:[UIColor commonGrayTextColor]];
        [_periodUnitLable setFont:[UIFont systemFontOfSize:15]];
        [_periodUnitLable setText:@"次"];
    }
    return _periodUnitLable;
}
@end
