//
//  HealthDetectWarningTypeView.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/21.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthDetectWarningTypeView.h"

@interface HealthDetectWarningTypeControl : UIControl

@property (nonatomic, strong) UILabel* identificationLable;
@property (nonatomic, strong) UIImageView* arrowImageView;

- (void) setWarningType:(NSString*) typeString;
@end

@implementation HealthDetectWarningTypeControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.identificationLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.right.equalTo(self).offset(-12.5);
    }];
}

- (void) setWarningType:(NSString*) typeString
{
    [self.identificationLable setText:typeString];
}

#pragma mark - settingAndGetting
- (UILabel*) identificationLable
{
    if (!_identificationLable) {
        _identificationLable = [[UILabel alloc] init];
        [self addSubview:_identificationLable];
        [_identificationLable setTextColor:[UIColor commonTextColor]];
        [_identificationLable setFont:[UIFont systemFontOfSize:15]];
    }
    return _identificationLable;
}

- (UIImageView*) arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_down_list_arrow"]];
        [self addSubview:_arrowImageView];
    }
    return _arrowImageView;
}
@end

@interface HealthDetectWarningTypeView ()

@property (nonatomic, strong) UILabel* titleLable;

@end

@implementation HealthDetectWarningTypeView

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
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12.5);
        make.centerY.equalTo(self);
    }];
    
    [self.typeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-12.5);
        make.left.equalTo(self.titleLable.mas_right).offset(15);
        make.height.equalTo(self).offset(-30);
    }];
}

- (void) setWarningType:(NSString*) typeString
{
    HealthDetectWarningTypeControl* control = (HealthDetectWarningTypeControl*)self.typeControl;
    [control setWarningType:typeString];
}

#pragma mark - settingAndGetting
- (UILabel*) titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        [self addSubview:_titleLable];
        
        [_titleLable setTextColor:[UIColor commonTextColor]];
        [_titleLable setText:@"预警标识"];
        [_titleLable setFont:[UIFont systemFontOfSize:15]];
    }
    return _titleLable;
}

- (UIControl*) typeControl
{
    if (!_typeControl) {
        _typeControl = [[HealthDetectWarningTypeControl alloc] init];
        [self addSubview:_typeControl];
    }
    return _typeControl;
}
@end
