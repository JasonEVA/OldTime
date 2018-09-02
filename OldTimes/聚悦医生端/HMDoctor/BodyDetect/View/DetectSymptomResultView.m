//
//  DetectSymptomResultView.m
//  HMDoctor
//
//  Created by lkl on 2017/4/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "DetectSymptomResultView.h"
#import "BodyTemperatureDetectRecord.h"
#import "BreathingDetctRecord.h"

@interface DetectSymptomResultView ()

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation DetectSymptomResultView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentLabel];
        
        [self configConstraints];
    }
    return self;
}

#pragma mark -- Medthod

// 设置约束
- (void)configConstraints {
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(self).offset(10);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(self).with.offset(-12.5);
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(7);
    }];
}

- (void)setDetectResult:(DetectResult *) detectResult
{
    if (!detectResult) {
        return;
    }
    
    //体温
    if ([detectResult isKindOfClass:[BodyTemperatureDetectResult class]]) {
        BodyTemperatureDetectResult *bodyTemperatureResult = (BodyTemperatureDetectResult *) detectResult;
        
        [_contentLabel setText:bodyTemperatureResult.symptom];
    }

    //呼吸
    if ([detectResult isKindOfClass:[BreathingDetctResult class]]) {
        BreathingDetctResult* breathResult = (BreathingDetctResult*) detectResult;
        
        [_contentLabel setText:breathResult.symptom];
    }
}

#pragma mark --init
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [_titleLabel setTextColor:[UIColor mainThemeColor]];
        [_titleLabel setFont:[UIFont font_32]];
        [_titleLabel setText:@"备注"];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setTextColor:[UIColor commonTextColor]];
        [_contentLabel setFont:[UIFont font_28]];
    }
    return _contentLabel;
}

@end
