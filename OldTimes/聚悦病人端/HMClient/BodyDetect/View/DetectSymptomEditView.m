//
//  DetectSymptomEditView.m
//  HMClient
//
//  Created by lkl on 2017/4/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

//监测设备结果页症状备注通用view
#import "DetectSymptomEditView.h"

@interface DetectSymptomEditView ()

@property (nonatomic,strong) UIImageView *lineImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation DetectSymptomEditView

- (id) init{
    self = [super init];
    if (self){
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:self.lineImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.delButton];
        [self addSubview:self.lineView];
        [self addSubview:self.editButton];
        
        [self configConstraints];
    }
    return self;
}

#pragma mark -- Medthod

// 设置约束
- (void)configConstraints {
    
    [_lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12.5);
        make.top.equalTo(self).offset(12);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lineImageView);
        make.left.equalTo(_lineImageView.mas_right).offset(4);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(_titleLabel.mas_bottom).offset(7);
        make.right.equalTo(self).with.offset(-12.5);
    }];
    
    [_delButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12.5);
        make.top.equalTo(_contentLabel.mas_bottom).offset(5);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_delButton);
        make.right.equalTo(_delButton.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(1, 20));
    }];

    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_delButton);
        make.right.equalTo(_lineView.mas_left).offset(-5);
    }];
}

- (void)setDetectResult:(DetectResult *) detectResult
{
    if (!detectResult || ![detectResult isKindOfClass:[BodyTemperatureDetectResult class]]) {
        return;
    }
    BodyTemperatureDetectResult *bodyTemperatureResult = (BodyTemperatureDetectResult *) detectResult;
    
    [_contentLabel setText:bodyTemperatureResult.symptom];
}

#pragma mark -- UI init
- (UIImageView *)lineImageView{
    if (!_lineView) {
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_list_line"]];
    }
    return _lineImageView;
}

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

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [_lineView setBackgroundColor:[UIColor mainThemeColor]];
    }
    return _lineView;
}

- (UIButton *)editButton{
    if (!_editButton) {
        _editButton = [UIButton new];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton.titleLabel setFont:[UIFont font_26]];
        [_editButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
    }
    return _editButton;
}

- (UIButton *)delButton{
    if (!_delButton) {
        _delButton = [UIButton new];
        [_delButton setTitle:@"删除" forState:UIControlStateNormal];
        [_delButton.titleLabel setFont:[UIFont font_26]];
        [_delButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
    }
    return _delButton;
}

@end
