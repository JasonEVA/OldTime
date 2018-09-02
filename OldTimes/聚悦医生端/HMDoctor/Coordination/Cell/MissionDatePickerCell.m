//
//  MissionDatePickerCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionDatePickerCell.h"
#import "UIColor+Common.h"

@interface MissionDatePickerCell ()

/**
 *  取消按钮
 */
@property (nonatomic, strong) UIButton *btnCancel;
/**
 *  时间选择器
 */
@property(nonatomic, strong) UIDatePicker  *datePicker;
/**
 *  右上角的确认按钮
 */
@property(nonatomic, strong) UIButton *deadLineokBtn;

@property(nonatomic, strong) NSDate *deadlineDate;

@property (nonatomic, strong) UILabel *wholeDayLabel;
@property (nonatomic, strong) UISwitch *wholeDaySwitch;
@property (nonatomic, strong) UIButton *noSelectTime;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSDate *minDate;
@end

@implementation MissionDatePickerCell
+ (NSString *)identifier { return NSStringFromClass([self class]);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.deadLineokBtn];
        [self.deadLineokBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView).offset(15);
        }];
        [self.contentView addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.contentView).offset(15);
        }];
        
        [self.contentView addSubview:self.datePicker];
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.height.mas_equalTo(150);
            make.top.equalTo(self.btnCancel).offset(30);
        }];
        
        
        [self.contentView addSubview:self.noSelectTime];
        [self.noSelectTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.datePicker.mas_bottom).offset(20);
        }];
        [self.contentView addSubview:self.wholeDayLabel];
        [self.wholeDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.noSelectTime);
        }];

        
        [self.contentView addSubview:self.wholeDaySwitch];
        [self.wholeDaySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.noSelectTime);
            make.left.equalTo(self.wholeDayLabel.mas_right).offset(15);
        }];
        
       
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)setDate:(NSDate *)date {
    [self.datePicker setDate:date animated:NO];
}

- (void)wholeDayIsOn:(BOOL)isOn {
    [self.wholeDaySwitch setOn:isOn];
    [self switchValueChanged:self.wholeDaySwitch];
}

- (void)setMyMaxDate:(NSDate *)MaxDate MinDate:(NSDate *)MinDate
{
    [self.datePicker setMaximumDate:MaxDate];
    [self.datePicker setMinimumDate:MinDate];
}



#pragma mark - Private Method
- (void)switchValueChanged:(UISwitch *)aSwitch {
    if (aSwitch.isOn) {
        [self.datePicker setDatePickerMode:UIDatePickerModeDate];
        self.datePicker.minimumDate = [NSDate date];
    }
    else {
        [self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        self.datePicker.minimumDate = [[NSDate date] dateByAddingMinutes:10];
    }
    
    [self.datePicker setDate:[self.datePicker date] animated:NO];
}



- (void)dismiss:(UIButton *)btn
{
    BOOL isNone;
    if ([self.delegate respondsToSelector:@selector(MissionDatePickerCellCallBack_didSelectAtIndexPath:date:isWholeDay:isNone:)]) {
        id date = nil;
        if (btn.tag == 0) {
            isNone = NO;
        } else if(btn.tag == 1) {
            date = self.datePicker.date;
            isNone = NO;
        } else if(btn.tag == 2) {
            isNone = YES;
        }
        [self.delegate MissionDatePickerCellCallBack_didSelectAtIndexPath:self.indexPath date:date isWholeDay:self.wholeDaySwitch.on isNone:isNone];
    }
}


- (UIDatePicker *)datePicker
{
    if (!_datePicker)
    {
        _datePicker = [UIDatePicker new];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        //在当前时间上加十分钟
//        [_datePicker setMinimumDate:[[NSDate date] dateByAddingMinutes:10]];
        [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    }
    return _datePicker;
}

- (UILabel *)wholeDayLabel {
    if (!_wholeDayLabel) {
        _wholeDayLabel = [UILabel new];
        _wholeDayLabel.text = @"全天";
        _wholeDayLabel.font = [UIFont systemFontOfSize:18];
    }
    return _wholeDayLabel;
}

- (UISwitch *)wholeDaySwitch {
    if (!_wholeDaySwitch) {
        _wholeDaySwitch = [UISwitch new];
        [_wholeDaySwitch setOn:YES];
        [_wholeDaySwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_wholeDaySwitch setOnTintColor:[UIColor mainThemeColor]];
    }
    return _wholeDaySwitch;
}

- (UIButton *)btnCancel
{
    if (!_btnCancel)
    {
        _btnCancel = [[UIButton alloc] init];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        [_btnCancel setTag:0];
    }
    return _btnCancel;
}
- (UIButton *)deadLineokBtn
{
    if (!_deadLineokBtn)
    {
        _deadLineokBtn = [[UIButton alloc] init];
        [_deadLineokBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        [_deadLineokBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_deadLineokBtn setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [_deadLineokBtn setTag:1];
        //        [_deadLineokBtn setBackgroundImage:[[UIImage imageNamed:@"Calendar_check"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    return _deadLineokBtn;
}
- (UIButton *)noSelectTime
{
    if (!_noSelectTime) {
        _noSelectTime = [[UIButton alloc] init];
        [_noSelectTime addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        [_noSelectTime setTitle:@"无" forState:UIControlStateNormal];
        [_noSelectTime setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [_noSelectTime setTag:2];
        [_noSelectTime setHidden:YES];
    }
    return _noSelectTime;
}

@end
