//
//  CalendarNewTimeDaySelectTableViewCell.m
//  launcher
//
//  Created by William Zhang on 15/8/4.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarNewTimeDaySelectTableViewCell.h"
#import "DayByDaySelectCalendarView.h"
#import <DateTools/DateTools.h>
#import <Masonry/Masonry.h>
#import "UIView+Util.h"
#import "Category.h"
#import "MyDefine.h"

@interface CalendarNewTimeDaySelectTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *lbTimes;
@property (nonatomic, strong) UIButton *trashButton;
@property (nonatomic, strong) DayByDaySelectCalendarView *calendarView;

@property (nonatomic, strong) UILabel  *allDayLabel;
@property (nonatomic, strong) UISwitch *allDaySwitch;

@property (nonatomic, copy) CalendarNewTimeDeleteBlock    block;
@property (nonatomic, copy) CalendarNewTimeDidChangeBlock didChangeBlock;
@property (nonatomic, copy) void (^switchBlock)();

@end

@implementation CalendarNewTimeDaySelectTableViewCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);;
}

+ (CGFloat)height {
    return 260;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.lbTimes];
    [self.contentView addSubview:self.trashButton];
    [self.contentView addSubview:self.calendarView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
    }];
    
    [self.trashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-13);
        make.centerY.equalTo(self.titleLabel);
        make.width.height.equalTo(@20);
    }];
    
    [self.lbTimes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.top.bottom.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-33);
    }];
    
    [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.right.equalTo(self.contentView);
    }];
    
    // 增大垃圾桶响应
    UIView *viewTap = [[UIView alloc] init];
    viewTap.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:viewTap];
    
    [viewTap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToDelete)];
    [viewTap addGestureRecognizer:tapGesture];
    
    [self.contentView addSubview:self.allDayLabel];
    [self.contentView addSubview:self.allDaySwitch];
    
    [self.allDaySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-8);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.allDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.allDaySwitch.mas_left).offset(-10);
        make.centerY.equalTo(self.allDaySwitch);
    }];
}

- (void)prepareForReuse {
    [self.calendarView resetDate];
    [super prepareForReuse];
}

#pragma mark - Interface Method
- (void)setTitle:(NSString *)title showTrash:(BOOL)showTrash {
    self.titleLabel.text = title;
    self.trashButton.hidden = !showTrash;
}

- (void)setDeleteBlock:(CalendarNewTimeDeleteBlock)block didChange:(CalendarNewTimeDidChangeBlock)didChangeBlock {
    self.block = block;
    self.didChangeBlock = didChangeBlock;
}

- (void)setStartDate:(NSDate *)date endData:(NSDate *)endDate {
    [self.calendarView setStartDate:date endData:endDate];
    self.lbTimes.text = [date mtc_startToEndDate:endDate wholeDay:YES];
}

- (void)showAllDaySwitch {
    self.allDaySwitch.hidden = NO;
    self.allDayLabel.hidden = NO;
    [self.allDaySwitch setOn:YES];
}

- (void)switchDay:(void (^)())switchBlock {
    self.switchBlock = switchBlock;
}

#pragma mark - Button Click
- (void)clickToDelete {
    //按钮暴力点击防御
    [self.trashButton mtc_deterClickedRepeatedly];
    
    if (self.block && !self.trashButton.hidden) {
        self.block(self);
    }
}

- (void)calendarValueDidChange:(DayByDaySelectCalendarView *)calendarView {
    // 选择日期变换
    if (self.didChangeBlock) {
        self.didChangeBlock(self, [calendarView selectedDateInComponent:0], [calendarView selectedDateInComponent:1]);
        self.lbTimes.text = [[calendarView selectedDateInComponent:0] mtc_startToEndDate:[calendarView selectedDateInComponent:1] wholeDay:YES];
    }
}

- (void)clickToSwitch {
    !self.switchBlock ?: self.switchBlock();
}

#pragma mark - Initializer
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _titleLabel.textColor = [UIColor minorFontColor];
    }
    return _titleLabel;
}

- (UIButton *)trashButton {
    if (!_trashButton) {
        _trashButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _trashButton.expandSize = CGSizeMake(10, 10);
        [_trashButton setImage:[UIImage imageNamed:@"Calendar_trash"] forState:UIControlStateNormal];
        [_trashButton addTarget:self action:@selector(clickToDelete) forControlEvents:UIControlEventTouchUpInside];
    }
    return _trashButton;
}

- (DayByDaySelectCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[DayByDaySelectCalendarView alloc] init];
        [_calendarView addTarget:self action:@selector(calendarValueDidChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _calendarView;
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
        [_lbTimes setFont:[UIFont mtc_font_28]];
        [_lbTimes setTextAlignment:NSTextAlignmentLeft];
        [_lbTimes setAdjustsFontSizeToFitWidth:YES];
    }
    return _lbTimes;
}
@end
