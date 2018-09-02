//
//  TrainFinishInputView.m
//  Shape
//
//  Created by jasonwang on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainFinishInputView.h"
#import "UILabel+EX.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import <Masonry.h>

@implementation TrainFinishInputView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self initComponent];
        [self updateConstraints];
    }
    return self;
}

#pragma mark -private method
- (void)initComponent
{
    [self addSubview:self.finishTitelLb];
    [self addSubview:self.todayDataLb];
    [self addSubview:self.time];
    [self addSubview:self.timeLb];
    [self addSubview:self.action];
    [self addSubview:self.actionLb];
    [self addSubview:self.cost];
    [self addSubview:self.costLb];
    [self addSubview:self.imageView];
    [self addSubview:self.button];
    [self addSubview:self.line2];
    [self addSubview:self.line1];
}

- (void)click
{
    if ([self.delegate respondsToSelector:@selector(TrainFinishInputViewDelegate_callBack)]) {
        [self.delegate TrainFinishInputViewDelegate_callBack];
    }

}

#pragma mark - event Response

#pragma mark - request Delegate

#pragma mark - updateViewConstraints

- (void)updateConstraints
{
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(37);
        make.centerX.equalTo(self);
    }];
    
    [self.finishTitelLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(14);
        make.centerX.equalTo(self);
    }];
    
    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.finishTitelLb.mas_bottom).offset(25);
    }];
    
    [self.todayDataLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1.mas_bottom).offset(30);
        make.centerX.equalTo(self);
    }];
    
    [self.actionLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.todayDataLb.mas_bottom).offset(25);
    }];
    
    [self.action mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.actionLb.mas_bottom).offset(15);
    }];
    
    [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.actionLb);
        make.left.equalTo(self).offset(26);
    }];
    
    [self.time mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.action);
        make.centerX.equalTo(self.timeLb);
    }];
    [self.costLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.actionLb);
        make.right.equalTo(self).offset(-26);
    }];
    
    [self.cost mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.action);
        make.centerX.equalTo(self.costLb);
    }];
    
    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(self).multipliedBy(0.124);
    }];
    
    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.button.mas_top);
    }];
    
    [super updateConstraints];
    
}

#pragma mark - init UI

- (UILabel *)finishTitelLb
{
    if (!_finishTitelLb) {
        _finishTitelLb = [UILabel setLabel:_finishTitelLb text:@"训练完成" font:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor]];
    }
    return _finishTitelLb;
}
- (UILabel *)todayDataLb
{
    if (!_todayDataLb) {
        _todayDataLb = [UILabel setLabel:_todayDataLb text:@"今日数值" font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor]];
    }
    return _todayDataLb;
}
- (UILabel *)time
{
    if (!_time) {
        _time = [UILabel setLabel:_time text:@"17" font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor]];
         _time.font = [UIFont fontWithName:fontName_BebasNeue size:18];
    }
    return _time;
}
- (UILabel *)timeLb
{
    if (!_timeLb) {
        _timeLb = [UILabel setLabel:_timeLb text:@"时长(min)" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorLightGray_898888]];
    }
    return _timeLb;
}
- (UILabel *)action
{
    if (!_action) {
        _action = [UILabel setLabel:_action text:@"12" font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor]];
        _action.font = [UIFont fontWithName:fontName_BebasNeue size:18];
    }
    return _action;
}
- (UILabel *)actionLb
{
    if (!_actionLb) {
        _actionLb = [UILabel setLabel:_actionLb text:@"动作" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorLightGray_898888]];
    }
    return _actionLb;
}
- (UILabel *)cost
{
    if (!_cost) {
        _cost = [UILabel setLabel:_cost text:@"600" font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor]];
        _cost.font = [UIFont fontWithName:fontName_BebasNeue size:18];
    }
    return _cost;
}
- (UILabel *)costLb
{
    if (!_costLb) {
        _costLb = [UILabel setLabel:_costLb text:@"消耗(kcal)" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorLightGray_898888]];
    }
    return _costLb;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"train_finish"]];
    }
    return _imageView;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc]init];
        [_button setTitle:@"确定" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor themeOrange_ff5d2b] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [_button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UIView *)line1
{
    if (!_line1) {
        _line1 = [[UIView alloc]init];
        [_line1 setBackgroundColor:[UIColor colorLightGray_989898]];
    }
    return _line1;
}
- (UIView *)line2
{
    if (!_line2) {
        _line2 = [[UIView alloc]init];
        [_line2 setBackgroundColor:[UIColor colorLightGray_989898]];
    }
    return _line2;
}
@end
