//
//  ChatNewTaskSelectTimeTableViewCell.m
//  launcher
//
//  Created by Lars Chen on 15/10/8.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatNewTaskSelectTimeTableViewCell.h"
#import <Masonry.h>
#import "MyDefine.h"
#import "UIColor+Hex.h"

#define COLOR_FONT_GRAY         [UIColor mtc_colorWithHex:0x666666]

static NSInteger const miniteInterval = 5;

@interface ChatNewTaskSelectTimeTableViewCell ()

@property (nonatomic, strong) UILabel *lbTime;
@property (nonatomic, strong) UILabel *lbDay;
@property (nonatomic, strong) UISwitch *swithAllDay;

@end

@implementation ChatNewTaskSelectTimeTableViewCell

- (instancetype)init
{
    if (self = [super init])
    {
        [self initComponents];
    }
    
    return self;
}

- (void)initComponents
{
    [self.contentView addSubview:self.lbTime];
    [self.contentView addSubview:self.lbDay];
    [self.contentView addSubview:self.swithAllDay];
    [self.contentView addSubview:self.datePicker];
    
    [self initConstraints];
}

- (void)initConstraints
{
    [self.lbTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(8);
        make.top.equalTo(self.contentView).offset(16);
    }];
    
    [self.swithAllDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-8.5);
        make.centerY.equalTo(self.lbTime);
    }];
    
    [self.lbDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.swithAllDay.mas_left).offset(-18.5);
        make.bottom.equalTo(self.lbTime);
    }];
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbTime.mas_bottom).offset(13);
        make.left.equalTo(self.contentView).offset(13);
        make.right.equalTo(self.contentView).offset(-13);
        make.bottom.equalTo(self.contentView).offset(-35);
    }];
}

- (void)switchValueChanged:(UISwitch *)aSwitch {
    if (aSwitch.isOn) {
        [self.datePicker setDatePickerMode:UIDatePickerModeDate];
        self.datePicker.minimumDate = [NSDate date];
    }
    else {
        [self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    }
}

#pragma mark - Init UI
- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        NSLocale *locale = [[UnifiedUserInfoManager share] getLocaleIdentifier];
        [_datePicker setLocale:locale];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.minuteInterval = miniteInterval;
        [_datePicker setTintColor:[UIColor themeBlue]];
    }
    return _datePicker;
}

- (UILabel *)lbTime
{
    if (!_lbTime)
    {
        _lbTime = [UILabel new];
        [_lbTime setFont:[UIFont systemFontOfSize:15]];
        [_lbTime setTextColor:COLOR_FONT_GRAY];
        [_lbTime setText:LOCAL(CALENDAR_ADD_CHOOSETIME)];
    }
    
    return _lbTime;
}

- (UILabel *)lbDay
{
    if (!_lbDay)
    {
        _lbDay = [UILabel new];
        [_lbDay setFont:[UIFont systemFontOfSize:15]];
        [_lbDay setTextColor:COLOR_FONT_GRAY];
        [_lbDay setText:LOCAL(APPLY_ALLDAY)];
    }
    
    return _lbDay;
}

- (UISwitch *)swithAllDay
{
    if (!_swithAllDay)
    {
        _swithAllDay = [UISwitch new];
        [_swithAllDay setOn:YES];
        [_swithAllDay addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _swithAllDay;
}


@end
