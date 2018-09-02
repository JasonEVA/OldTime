//
//  NewCalendarMeetingDetailCell.m
//  launcher
//
//  Created by kylehe on 16/5/27.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarMeetingDetailCell.h"
#import <Masonry/Masonry.h>
#import "CalendarLaunchrModel.h"
#import "NSDate+String.h"
@interface NewCalendarMeetingDetailCell ()

@property(nonatomic, strong) UILabel  *titleLabel;
@property(nonatomic, strong) UILabel  *timeLabel;
@property(nonatomic, strong) UILabel  *addressLabel;
@property(nonatomic, strong) UIImageView  *calendarIcon; 
@property(nonatomic, strong) UIImageView  *timeIcon;
@property(nonatomic, strong) UIImageView  *addressIcon;
@property(nonatomic, strong) UIView  *seprateLine;

@end
@implementation NewCalendarMeetingDetailCell

+(NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createFrame];
    }
    return self;
}

#pragma mark - interfaceMethod
- (void)setDateWithModel:(CalendarLaunchrModel *)model
{
    self.titleLabel.text = model.title;
    NSDate *startDate = model.time[0];
    NSDate *endDate = model.time[1];
    self.timeLabel.text = [startDate mtc_startToEndDate:endDate];
    self.addressLabel.text = model.place.name;
}

#pragma mark - privateMethod
- (void)createFrame
{
    [self.contentView addSubview:self.calendarIcon];
    [self.calendarIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(15);
        make.width.height.equalTo(@(18));
    }];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.calendarIcon.mas_right).offset(20);
        make.centerY.equalTo(self.calendarIcon);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    
    [self.contentView addSubview:self.timeIcon];
    [self.timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.calendarIcon);
        make.top.equalTo(self.calendarIcon.mas_bottom).offset(15);
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeIcon);
        make.right.left.equalTo(self.titleLabel);
    }];
    
    [self.contentView addSubview:self.addressIcon];
    [self.addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.timeIcon);
        make.width.equalTo(@14);
        make.top.equalTo(self.timeIcon.mas_bottom).offset(15);
    }];
    
    [self.contentView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.timeLabel);
        make.centerY.equalTo(self.addressIcon);
    }];
    [self.contentView addSubview:self.seprateLine];
    [self.seprateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}


#pragma mark - setterAndGetter
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _timeLabel;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel)
    {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textAlignment = NSTextAlignmentLeft ;
        _addressLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _addressLabel;
}

- (UIImageView *)calendarIcon
{
    if (!_calendarIcon)
    {
        _calendarIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Meeting_EventName"]];
    }
    return _calendarIcon;
}

- (UIImageView *)timeIcon
{
    if (!_timeIcon)
    {
        _timeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Meeting_EventTime"]];
    }
    return _timeIcon;
}

- (UIImageView *)addressIcon
{
    if (!_addressIcon)
    {
        _addressIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Meeting_EventAddress"]];
    }
    return _addressIcon;
}

- (UIView *)seprateLine
{
    if (!_seprateLine)
    {
        _seprateLine = [[UIView alloc] init];
        _seprateLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _seprateLine;
}
@end
