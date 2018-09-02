//
//  TrainDayDetailInfoCell.m
//  Shape
//
//  Created by jasonwang on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainDayDetailInfoCell.h"
#import "UILabel+EX.h"
#import "UIColor+Hex.h"
#import <Masonry.h>
#import "MyDefine.h"

@implementation TrainDayDetailInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initComponent];
        [self updateConstraints];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

#pragma mark -private method

- (void)initComponent
{
    [self addSubview:self.trainNameLb];
    [self addSubview:self.trainName];
    [self addSubview:self.totalDayNum];
    [self addSubview:self.todayNum];
    [self addSubview:self.time];
    [self addSubview:self.timeLb];
    [self addSubview:self.action];
    [self addSubview:self.actionLb];
    [self addSubview:self.cost];
    [self addSubview:self.costLb];
}

- (void)setMyData:(TrainGetDayTrainInfoModel *)model
{
    [self.trainName setText:model.trainingName];
    [self.todayNum setText:[NSString stringWithFormat:@"%ld",model.daysNo]];
    [self.totalDayNum setText:[NSString stringWithFormat:@"/%ld天",model.totalTime]];
    
    if (model.classify == 0) {
        [self.time setText:[NSString stringWithFormat:@"%ld分",model.length]];
        [self.cost setText:[NSString stringWithFormat:@"%ld卡",model.consumption]];
        [self.action setText:[NSString stringWithFormat:@"%ld个",model.actionList.count]];
    }else{
        [self.timeLb setText:@"消耗"];
        [self.time setText:[NSString stringWithFormat:@"%ld卡",model.consumption]];
        [self.cost setHidden:YES];
        [self.costLb setHidden:YES];
        [self.action setHidden:YES];
        [self.actionLb setHidden:YES];
    }
    
    
}

#pragma mark - event Response

#pragma mark - request Delegate

#pragma mark - updateViewConstraints
- (void)updateConstraints
{
    [self.trainNameLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(18);
        make.left.equalTo(self).offset(27);
    }];
    
    [self.trainName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.trainNameLb.mas_right).offset(8);
        make.centerY.equalTo(self.trainNameLb);
        make.right.lessThanOrEqualTo(self.timeLb.mas_left);
    }];
    
    [self.totalDayNum mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.todayNum.mas_right).offset(3);
        make.bottom.equalTo(self).offset(-18);
    }];
    
    [self.todayNum mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.totalDayNum).offset(5);
        make.left.equalTo(self.trainNameLb);
    }];
    
    [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(44);
        make.centerY.equalTo(self.trainNameLb);
    }];
    
    [self.time mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLb.mas_right).offset(13);
        make.centerY.equalTo(self.timeLb);
        make.right.lessThanOrEqualTo(self.contentView);
    }];
    
    [self.costLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.totalDayNum);
        make.left.equalTo(self.timeLb);
    }];
    
    [self.cost mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.costLb);
        make.left.equalTo(self.time);
        make.right.lessThanOrEqualTo(self.contentView);
    }];
    
    [self.action mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.time);
        make.right.lessThanOrEqualTo(self.contentView);
    }];
    
    [self.actionLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.action);
        make.left.equalTo(self.timeLb);
    }];
    
    [super updateConstraints];
}
#pragma mark - init UI
- (UILabel *)trainName
{
    if (!_trainName) {
        _trainName = [UILabel setLabel:_trainName text:@"腹肌燃烧" font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor]];
    }
    return _trainName;
}

- (UILabel *)trainNameLb
{
    if (!_trainNameLb) {
        _trainNameLb = [UILabel setLabel:_trainNameLb text:@"今日训练" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorLightGray_898888]];
    }
    return _trainNameLb;
}
- (UILabel *)todayNum
{
    if (!_todayNum) {
        _todayNum = [UILabel setLabel:_todayNum text:@"1" font:[UIFont systemFontOfSize:30] textColor:[UIColor whiteColor]];
        _todayNum.font = [UIFont fontWithName:fontName_BebasNeue size:30];
    }
    return _todayNum;
}
- (UILabel *)totalDayNum
{
    if (!_totalDayNum) {
        _totalDayNum = [UILabel setLabel:_totalDayNum text:@"/8天" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorLightGray_898888]];
    }
    return _totalDayNum;
}
- (UILabel *)time
{
    if (!_time) {
        _time = [UILabel setLabel:_time text:@"17分" font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor]];
    }
    return _time;
}
- (UILabel *)timeLb
{
    if (!_timeLb) {
        _timeLb = [UILabel setLabel:_timeLb text:@"当次时长" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorLightGray_898888]];
    }
    return _timeLb;
}
- (UILabel *)action
{
    if (!_action) {
        _action = [UILabel setLabel:_action text:@"12个" font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor]];
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
        _cost = [UILabel setLabel:_cost text:@"60卡" font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor]];
    }
    return _cost;
}
- (UILabel *)costLb
{
    if (!_costLb) {
        _costLb = [UILabel setLabel:_costLb text:@"消耗" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorLightGray_898888]];
    }
    return _costLb;
}

@end
