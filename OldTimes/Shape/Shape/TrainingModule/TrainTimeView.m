//
//  TrainTimeView.m
//  Shape
//
//  Created by jasonwang on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainTimeView.h"
#import "UILabel+EX.h"
#import "MyDefine.h"
#import <Masonry.h>

@implementation TrainTimeView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initComponent];
        [self updateConstraints];
    }
    return self;
}

#pragma mark -private method
- (void)initComponent
{
    [self addSubview:self.allTimeLb];
    [self addSubview:self.allTimeNum];
    [self addSubview:self.eachDayLb];
    [self addSubview:self.eachDayNum];
    [self addSubview:self.costLb];
    [self addSubview:self.costNum];
    
}

- (void)setMyData:(TrainGetTrainInfoModel *)model
{
    [self.allTimeNum setText:[NSString stringWithFormat:@"%ld",model.totalTime]];
    [self.eachDayNum setText:[NSString stringWithFormat:@"%ld",model.avgTime]];
    [self.costNum setText:[NSString stringWithFormat:@"%ld",model.totalConsumption]];

}
#pragma mark - event Response

#pragma mark - request Delegate

#pragma mark - updateViewConstraints
- (void)updateConstraints
{
    [self.allTimeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
    }];
    [self.allTimeNum mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.allTimeLb);
        make.top.equalTo(self.allTimeLb.mas_bottom).offset(13);
    }];
    [self.eachDayLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
    }];
    [self.eachDayNum mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.eachDayLb);
        make.top.equalTo(self.allTimeNum);
    }];
    
    [self.costLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
    }];
    [self.costNum mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.allTimeNum);
        make.centerX.equalTo(self.costLb);
    }];
    [super updateConstraints];
}
#pragma mark - init UI
- (UILabel *)allTimeLb
{
    if (!_allTimeLb) {
        _allTimeLb = [UILabel setLabel:_allTimeLb text:@"总时长(day)" font:[UIFont systemFontOfSize:fontSize_13] textColor:[UIColor whiteColor]];
    }
    return _allTimeLb;
}

- (UILabel *)allTimeNum
{
    if (!_allTimeNum) {
        _allTimeNum = [UILabel setLabel:_allTimeNum text:@"7" font:[UIFont systemFontOfSize:fontSize_18] textColor:[UIColor whiteColor]];
    }
    return _allTimeNum;
}

- (UILabel *)eachDayLb
{
    if (!_eachDayLb) {
        _eachDayLb = [UILabel setLabel:_eachDayLb text:@"日均(分)" font:[UIFont systemFontOfSize:fontSize_13] textColor:[UIColor whiteColor]];
    }
    return _eachDayLb;
}

- (UILabel *)eachDayNum
{
    if (!_eachDayNum) {
        _eachDayNum = [UILabel setLabel:_eachDayNum text:@"12" font:[UIFont systemFontOfSize:fontSize_13] textColor:[UIColor whiteColor]];
    }
    return _eachDayNum;
}

- (UILabel *)costLb
{
    if (!_costLb) {
        _costLb = [UILabel setLabel:_costLb text:@"总消耗(kcal)" font:[UIFont systemFontOfSize:fontSize_13] textColor:[UIColor whiteColor]];
    }
    return _costLb;
}

- (UILabel *)costNum
{
    if (!_costNum) {
        _costNum = [UILabel setLabel:_costNum text:@"156" font:[UIFont systemFontOfSize:fontSize_13] textColor:[UIColor whiteColor]];
    }
    return _costNum;
}


@end

