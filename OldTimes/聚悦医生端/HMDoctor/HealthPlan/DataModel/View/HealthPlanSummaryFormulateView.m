//
//  HealthPlanSummaryFormulateView.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSummaryFormulateView.h"

@interface HealthPlanSummaryFormulateView ()

@property (nonatomic, strong) UIImageView* unformulateImageView;
@property (nonatomic, strong) UILabel* formulateLabel;

@end

@implementation HealthPlanSummaryFormulateView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor commonBackgroundColor]];
        [self layoutElements];
        
        if (![HealthPlanUtil staffHasEditPrivilege:@"1"])
        {
            [self.formulateButton setHidden:YES];
        }
    }
    return self;
}

- (void) layoutElements
{
    [self.unformulateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-85);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [self.formulateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.unformulateImageView.mas_bottom).offset(15);
        make.centerX.equalTo(self);
    }];
    
    [self.formulateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.formulateLabel.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(100, 35));
        make.centerX.equalTo(self);
    }];
}

#pragma mark - settingAndGetting
- (UIImageView*) unformulateImageView
{
    if (!_unformulateImageView) {
        _unformulateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"healthplan_unformulate"]];
        [self addSubview:_unformulateImageView];
    }
    return _unformulateImageView;
}

- (UILabel*) formulateLabel
{
    if (!_formulateLabel) {
        _formulateLabel = [[UILabel alloc] init];
        [self addSubview:_formulateLabel];
        [_formulateLabel setText:@"用户的健康计划还没制定哦！"];
        [_formulateLabel setTextColor:[UIColor commonTextColor]];
        [_formulateLabel setFont:[UIFont systemFontOfSize:16]];
        
    }
    
    return _formulateLabel;
}

- (UIButton*) formulateButton
{
    if (!_formulateButton) {
        _formulateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_formulateButton];
        
        _formulateButton.layer.borderColor = [UIColor mainThemeColor].CGColor;
        _formulateButton.layer.borderWidth = 1;
        _formulateButton.layer.cornerRadius = 3;
        _formulateButton.layer.masksToBounds = YES;

        [_formulateButton setTitle:@"制定计划" forState:UIControlStateNormal];
        [_formulateButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [_formulateButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        _formulateButton.layer.cornerRadius = 4;
        _formulateButton.layer.masksToBounds = YES;
    }
    return _formulateButton;
}

@end

@interface HealthPlanSummaryCannotPerviewView ()

@property (nonatomic, strong) UILabel* cannotPerviewLabel;

@end

@implementation HealthPlanSummaryCannotPerviewView

- (instancetype)init
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
    [self.cannotPerviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(115);
    }];
}

- (UILabel*) cannotPerviewLabel
{
    if (!_cannotPerviewLabel) {
        _cannotPerviewLabel = [[UILabel alloc] init];
        [self addSubview:_cannotPerviewLabel];
        [_cannotPerviewLabel setText:@"对不起，您没有查看该条健康计划的权限！"];
        [_cannotPerviewLabel setTextColor:[UIColor commonTextColor]];
        [_cannotPerviewLabel setFont:[UIFont systemFontOfSize:16]];
        
    }
    
    return _cannotPerviewLabel;
}

@end
