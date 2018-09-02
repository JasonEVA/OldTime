//
//  FSRKTemperatureDetectingView.m
//  HMClient
//
//  Created by yinquan on 17/4/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "FSRKTemperatureDeviceDetectingView.h"

@interface FSRKTemperatureDeviceDetectingView ()

@property (nonatomic, readonly) UIImageView* deviceImageView;
@property (nonatomic, readonly) UILabel* explainLable;
@property (nonatomic, readonly) UILabel* detectingLable;

@end

@implementation FSRKTemperatureDeviceDetectingView

@synthesize deviceImageView = _deviceImageView;
@synthesize explainLable = _explainLable;
@synthesize detectingLable = _detectingLable;


- (instancetype)init
{
    self = [super init];
    if (self) {
        
       
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self.deviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(65);
        make.size.mas_equalTo(CGSizeMake(292.5, 148));
    }];
    
    [self.explainLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).with.offset(-166);
    }];
    
    [self.detectingLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(self).with.offset(-12.5);
        make.top.equalTo(self.explainLable.mas_bottom).with.offset(35);
        make.height.mas_equalTo(@45);
    }];
}

#pragma mark - setterAndGetter
- (UIImageView*) deviceImageView
{
    if (!_deviceImageView) {
        _deviceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fsrk_device_connected"]];
        [self addSubview:_deviceImageView];
    }
    
    return _deviceImageView;
}

- (UILabel*) explainLable
{
    if (!_explainLable) {
        _explainLable = [[UILabel alloc] init];
        [self addSubview:_explainLable];
        [_explainLable setFont:[UIFont font_24]];
        [_explainLable setTextColor:[UIColor commonTextColor]];
        [_explainLable setText:@"放入耳道，按下背部“SCAN ”按钮"];
    }
    
    return _explainLable;
}

- (UILabel*) detectingLable
{
    if (!_detectingLable) {
        _detectingLable = [[UILabel alloc] init];
        [self addSubview:_detectingLable];
        [_detectingLable setTextAlignment:NSTextAlignmentCenter];
        [_detectingLable setFont:[UIFont font_24]];
        [_detectingLable setTextColor:[UIColor mainThemeColor]];
        [_detectingLable setText:@"测量中..."];
        _detectingLable.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        _detectingLable.layer.borderWidth = 0.5;
        _detectingLable.layer.cornerRadius = 2.5;
        _detectingLable.layer.masksToBounds = YES;
    }
    return _detectingLable;
}

@end
