//
//  MeTrainHistoryDetailView.m
//  Shape
//
//  Created by jasonwang on 15/11/13.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeTrainHistoryDetailView.h"
#import "UILabel+EX.h"
#import "UIColor+Hex.h"
#import <Masonry.h>

@implementation MeTrainHistoryDetailView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initComponent];
        [self setBackgroundColor:[UIColor themeBackground_373737]];
    }
    return self;
}

#pragma mark -private method
- (void)initComponent
{
    [self addSubview:self.titelLb];
    [self addSubview:self.dayLb];
    [self addSubview:self.costDistanceValue];
    [self addSubview:self.costDistanceTitel];
    [self addSubview:self.timeValue];
    [self addSubview:self.timeTitel];
    [self addSubview:self.speedValue];
    [self addSubview:self.speedTitel];
    [self addSubview:self.imageView];
    [self needsUpdateConstraints];
}

- (void)setMyContent:(MeTrainHistoryDetailModel *)model
{
    [self.titelLb setText:[NSString stringWithFormat:@"完成“%@”",model.trainingName]];
    NSString *string = [NSString stringWithFormat:@"第%@天",model.daysNo];
    NSRange range1 = [string rangeOfString:@"第"];
    NSRange range2 = [string rangeOfString:@"天"];
    NSRange range = NSMakeRange(range1.location + 1,(range2.location - range1.location - 1));
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc]initWithString:string];
    [atr addAttribute:NSForegroundColorAttributeName value:[UIColor themeOrange_ff5d2b] range:range];
    [self.dayLb setAttributedText:atr];
}
#pragma mark - event Response

#pragma mark - request Delegate

#pragma mark - updateViewConstraints
- (void)updateConstraints
{
    [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(10);
    }];
    [self.dayLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titelLb);
        make.left.equalTo(self.titelLb.mas_right).offset(5);
        make.right.lessThanOrEqualTo(self.imageView.mas_left);
    }];
    [self.costDistanceTitel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLb);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.costDistanceValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.costDistanceTitel.mas_right).offset(5);
        make.centerY.equalTo(self.costDistanceTitel);
    }];
    
    [self.timeValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(-10);
        make.centerY.equalTo(self.costDistanceTitel);
    }];
    [self.timeTitel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeValue.mas_left).offset(-5);
        make.centerY.equalTo(self.timeValue);
    }];
    [self.speedValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self.costDistanceTitel);
    }];
    
    [self.speedTitel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.speedValue.mas_left).offset(-5);
        make.centerY.equalTo(self.costDistanceTitel);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-8);
        make.top.equalTo(self).offset(8);
    }];
    [super updateConstraints];
}
#pragma mark - init UI

- (UILabel *)titelLb
{
    if (!_titelLb) {
        _titelLb = [UILabel setLabel:_titelLb text:@"完成“零基础训练”" font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor]];
    }
    return _titelLb;
}

- (UILabel *)dayLb
{
    if (!_dayLb) {
        _dayLb = [UILabel setLabel:_titelLb text:@"第6天" font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor]];
    }
    return _dayLb;
}

- (UILabel *)costDistanceTitel
{
    if (!_costDistanceTitel) {
        _costDistanceTitel = [UILabel setLabel:_costDistanceTitel text:@"消耗" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorLightGray_898888]];
    }
    return _costDistanceTitel;
}
- (UILabel *)costDistanceValue
{
    if (!_costDistanceValue) {
        _costDistanceValue = [UILabel setLabel:_costDistanceValue text:@"327" font:[UIFont systemFontOfSize:14] textColor:[UIColor whiteColor]];
    }
    return _costDistanceValue;
}
- (UILabel *)timeTitel
{
    if (!_timeTitel) {
        _timeTitel = [UILabel setLabel:_timeTitel text:@"时长" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorLightGray_898888]];
    }
    return _timeTitel;
}
- (UILabel *)timeValue
{
    if (!_timeValue) {
        _timeValue = [UILabel setLabel:_timeValue text:@"00:30" font:[UIFont systemFontOfSize:14] textColor:[UIColor whiteColor]];
    }
    return _timeValue;
}
- (UILabel *)speedTitel
{
    if (!_speedTitel) {
        _speedTitel = [UILabel setLabel:_speedTitel text:@"配速" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorLightGray_898888]];
    }
    return _speedTitel;
}
- (UILabel *)speedValue
{
    if (!_speedValue) {
        _speedValue = [UILabel setLabel:_speedValue text:@"8’34" font:[UIFont systemFontOfSize:14] textColor:[UIColor whiteColor]];
    }
    return _speedValue;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"me_trainhistory"]];
    }
    return _imageView;
}
@end
