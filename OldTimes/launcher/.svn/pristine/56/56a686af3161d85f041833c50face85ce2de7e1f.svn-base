//
//  CalendarNewTimeDateSelectTableViewCell.m
//  launcher
//
//  Created by William Zhang on 15/7/31.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarNewTimeDateSelectTableViewCell.h"
#import <Masonry/Masonry.h>
#import <DateTools/DateTools.h>
#import "MyDefine.h"
#import "Category.h"

static NSInteger const miniteInterval = 5;

@interface CalendarNewTimeDateSelectTableViewCell ()

@property (nonatomic, strong) UILabel            *lbTitle;
@property (nonatomic, strong) UILabel            *lbTimes;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIButton     *btnTrash;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UILabel  *allDayLabel;
@property (nonatomic, strong) UISwitch *allDaySwitch;

/** 删除响应block */
@property (nonatomic, copy) CalendarNewTimeDeleteBlock block;
/** 时间更新block */
@property (nonatomic, copy) CalendarNewTimeDidChangeBlock didChangeBlock;
/** 点击segment Block */
@property (nonatomic, copy) calendarNewTimeSelectedSegmentIndexBlock selectedSegmentBlock;

@property (nonatomic, copy) void (^switchBlock)();

// Data
@property (nonatomic, strong) NSDate *firstDate;
@property (nonatomic, strong) NSDate *lastDate;

@end

@implementation CalendarNewTimeDateSelectTableViewCell

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);;
}

+ (CGFloat)height {
    return 280;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    [self.contentView addSubview:self.lbTitle];
    [self.contentView addSubview:self.lbTimes];
    [self.contentView addSubview:self.btnTrash];
    [self.contentView addSubview:self.segmentedControl];
    [self.contentView addSubview:self.datePicker];
    
    [self.contentView addSubview:self.allDayLabel];
    [self.contentView addSubview:self.allDaySwitch];
    
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
    }];
    
    [self.btnTrash mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-13);
        make.centerY.equalTo(self.lbTitle);
        make.width.height.equalTo(@50);
    }];
    
    [self.lbTimes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lbTitle.mas_right).offset(10);
        make.top.bottom.equalTo(self.lbTitle);
        make.right.equalTo(self.btnTrash.mas_left);
    }];
    
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbTitle.mas_bottom).offset(20);
        make.height.equalTo(@30);
        make.left.equalTo(self.contentView).offset(70);
        make.right.equalTo(self.contentView).offset(-70);
    }];
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedControl.mas_bottom).offset(5);
        make.left.right.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.allDayLabel];
    [self.contentView addSubview:self.allDaySwitch];
    
    [self.allDaySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-8);
        make.centerY.equalTo(self.lbTitle);
    }];
    
    [self.allDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.allDaySwitch.mas_left).offset(-10);
        make.centerY.equalTo(self.allDaySwitch);
    }];
}

#pragma mark - Interface Method
- (void)setTitle:(NSString *)title showTrash:(BOOL)showTrash
{
    self.lbTitle.text = title;
    self.btnTrash.hidden = !showTrash;
}

- (void)setDeleteBlock:(CalendarNewTimeDeleteBlock)block didChange:(CalendarNewTimeDidChangeBlock)didChangeBlock {
    self.block = block;
    self.didChangeBlock = didChangeBlock;
}

- (void)selectedSegmentIndexBlock:(calendarNewTimeSelectedSegmentIndexBlock)selecteBlock {
    self.selectedSegmentBlock = selecteBlock;
}

- (void)setStartDate:(NSDate *)date endData:(NSDate *)endDate {
    
    NSNumber *startChanged;
    NSNumber *endChanged;
    
    self.firstDate = [date mtc_calculatorMinuteIntervalDidChange:&startChanged];
    self.lastDate  = [endDate mtc_calculatorMinuteIntervalDidChange:&endChanged];
	if ([self.firstDate secondsFrom:self.lastDate] >= -60) {
        [self performSelector:@selector(dateValueChange) withObject:nil afterDelay:0.2];
	}
	
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self.datePicker setDate:self.firstDate];
    } else {
        [self.datePicker setDate:self.lastDate];
    }
    
    if ([startChanged boolValue] || [endChanged boolValue]) {
        [self performSelector:@selector(dateValueChange) withObject:nil afterDelay:0.2];
    }
    
    self.lbTimes.text = [self.firstDate mtc_startToEndDate:self.lastDate];
}

- (void)isSelectedStartSegment:(BOOL)isSelect {
    [self.segmentedControl setSelectedSegmentIndex:isSelect ? 0 : 1];
}

- (void)showAllDaySwitch {
    self.allDaySwitch.hidden = NO;
    self.allDayLabel.hidden = YES;
    [self.allDaySwitch setOn:NO];
}

- (void)switchDay:(void (^)())switchBlock {
    self.switchBlock = switchBlock;
}

#pragma mark - Button Click
- (void)clickToDelete {
    //按钮暴力点击防御
    [self.btnTrash mtc_deterClickedRepeatedly];
    
    if (self.block) {
        self.block(self);
    }
}

- (void)clickToSwitch {
    !self.switchBlock ?: self.switchBlock();
}

/** 时间选择器时间变化
 ** @note 与-60s比较是因为第一次创建datepicker时self.firstDate与self.lastDate有毫秒差距,
 **	而创建出来会截取秒表导致创建出相同开始时间与结束时间相同的事件,需要保证两者至少相差一小时.
 */
- (void)dateValueChange {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        self.firstDate = self.datePicker.date;
        if ([self.firstDate secondsFrom:self.lastDate] >= -60)
        {
            // 终止时间不能小于开始时间，默认加1小时
            self.lastDate = [self.firstDate dateByAddingHours:1];
        }
            
    } else {
        self.lastDate = self.datePicker.date;
        if ([self.firstDate secondsFrom:self.lastDate] >= -60)
        {
            self.firstDate = [self.lastDate dateByAddingHours:-1];
        }
    }
    
    if (self.didChangeBlock) {
        self.didChangeBlock(self, self.firstDate, self.lastDate);
        self.lbTimes.text = [self.firstDate mtc_startToEndDate:self.lastDate];
    }
}

/** segment选择 */
- (void)segmentValueChanged:(UISegmentedControl *)segmentedControl {
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self.datePicker setDate:self.firstDate animated:YES];
    } else {
        [self.datePicker setDate:self.lastDate animated:YES];
    }
    
    if (self.selectedSegmentBlock) {
        self.selectedSegmentBlock(self, segmentedControl.selectedSegmentIndex);
    }
}

#pragma mark - Initializer
- (UILabel *)lbTitle {
    if (!_lbTitle) {
        _lbTitle = [[UILabel alloc] init];
        _lbTitle.font = [UIFont mtc_font_30];
        [_lbTitle setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _lbTitle.textColor = [UIColor minorFontColor];
    }
    return _lbTitle;
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[LOCAL(CALENDAR_TIMEPICKER_STARTTIME), LOCAL(CALENDAR_TIMEPICKER_ENDTIME)]];
        [_segmentedControl setTintColor:[UIColor themeBlue]];
        [_segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.selectedSegmentIndex = 0;
    }
    return _segmentedControl;
}

- (UIButton *)btnTrash {
    if (!_btnTrash) {
        _btnTrash = [[UIButton alloc] init];
        [_btnTrash setImage:[UIImage imageNamed:@"Calendar_trash"] forState:UIControlStateNormal];
        _btnTrash.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_btnTrash addTarget:self action:@selector(clickToDelete) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnTrash;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        NSLocale *locale = [[UnifiedUserInfoManager share] getLocaleIdentifier];
        [_datePicker setLocale:locale];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _datePicker.minuteInterval = miniteInterval;
        [_datePicker addTarget:self action:@selector(dateValueChange) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (NSDate *)firstDate {
    if (!_firstDate) {
        _firstDate = [NSDate date];
    }
    return _firstDate;
}

- (NSDate *)lastDate {
    if (!_lastDate) {
        _lastDate = [NSDate date];
    }
    return _lastDate;
}

- (UILabel *)allDayLabel {
    if (!_allDayLabel) {
        _allDayLabel = [UILabel new];
        _allDayLabel.font = [UIFont mtc_font_30];
        _allDayLabel.textColor = [UIColor blackColor];
        _allDayLabel.text = LOCAL(APPLY_ALLDAY);
        _allDayLabel.hidden = YES;
    }
    return _allDayLabel;
}

- (UISwitch *)allDaySwitch {
    if (!_allDaySwitch) {
        _allDaySwitch = [UISwitch new];
        //[_allDaySwitch setOn:YES];
        [_allDaySwitch setOnTintColor:[UIColor themeBlue]];
        [_allDaySwitch addTarget:self action:@selector(clickToSwitch) forControlEvents:UIControlEventValueChanged];
        _allDaySwitch.hidden = YES;
    }
    return _allDaySwitch;
}

- (UILabel *)lbTimes
{
    if (!_lbTimes)
    {
        _lbTimes= [[UILabel alloc] init];
        [_lbTimes setTextColor:[UIColor blackColor]];
        [_lbTimes setFont:[UIFont mtc_font_30]];
        [_lbTimes setTextAlignment:NSTextAlignmentLeft];
        [_lbTimes setAdjustsFontSizeToFitWidth:YES];
    }
    return _lbTimes;
}
@end
