//
//  HealthPlanSportDetailView.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/29.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSportDetailView.h"

@implementation HealthPlanSportDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation HealthPlanSportTimeControl

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
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(12.5);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-12.5);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.arrowImageView.mas_left).offset(-7.5);
    }];
}

- (void) setHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) criteriaModel
{
    [self.timeLabel setText:[NSString stringWithFormat:@"%@min每天", criteriaModel.sportsTimes]];
}


#pragma mark - settingAndGetting
- (UILabel*) titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        [_titleLabel setText:@"运动时间"];
        
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor commonDarkGrayTextColor]];
    }
    return _titleLabel;
}

- (UILabel*) timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [self addSubview:_timeLabel];
        
        [_timeLabel setFont:[UIFont systemFontOfSize:14]];
        [_timeLabel setTextColor:[UIColor commonDarkGrayTextColor]];
    }
    return _timeLabel;
}

- (UIImageView*) arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"c_rightArrow"]];
        [self addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

- (void) setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self.arrowImageView setHidden:!enabled];
}

@end

@implementation HealthPlanSportStrengthControl

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
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(12.5);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-12.5);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
    
    [self.strengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.arrowImageView.mas_left).offset(-7.5);
    }];
}

- (void) setHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) criteriaModel
{
    [self.strengthLabel setText:[NSString stringWithFormat:@"%@", [criteriaModel sportStrength]]];
}

#pragma mark - settingAndGetting
- (UILabel*) titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        [_titleLabel setText:@"运动强度"];
        
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor commonDarkGrayTextColor]];
    }
    return _titleLabel;
}

- (UILabel*) strengthLabel
{
    if (!_strengthLabel) {
        _strengthLabel = [[UILabel alloc] init];
        [self addSubview:_strengthLabel];
        
        [_strengthLabel setFont:[UIFont systemFontOfSize:14]];
        [_strengthLabel setTextColor:[UIColor commonDarkGrayTextColor]];
    }
    return _strengthLabel;
}

- (UIImageView*) arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"c_rightArrow"]];
        [self addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

- (void) setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self.arrowImageView setHidden:!enabled];
}
@end

@implementation HealthPlanSportTypesControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(12.5);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-12.5);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
    
    [self.typesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.arrowImageView.mas_left).offset(-7.5);
    }];
}



#pragma mark - settingAndGetting
- (UILabel*) titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        [_titleLabel setText:@"推荐运动"];
        
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor commonDarkGrayTextColor]];
    }
    return _titleLabel;
}

- (UILabel*) typesLabel
{
    if (!_typesLabel) {
        _typesLabel = [[UILabel alloc] init];
        [self addSubview:_typesLabel];
        [_typesLabel setText:@"选择"];
        [_typesLabel setFont:[UIFont systemFontOfSize:14]];
        [_typesLabel setTextColor:[UIColor commonDarkGrayTextColor]];
    }
    return _typesLabel;
}

- (UIImageView*) arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"c_rightArrow"]];
        [self addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

- (void) setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self.typesLabel setHidden:!enabled];
    [self.arrowImageView setHidden:!enabled];
}
@end
