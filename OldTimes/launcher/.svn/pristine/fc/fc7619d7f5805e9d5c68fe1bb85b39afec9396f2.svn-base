//
//  CalendarMonthTableViewCell.m
//  Titans
//
//  Created by Wythe Zhou on 10/29/14.
//  Copyright (c) 2014 Remon Lv. All rights reserved.
//

#import "CalendarMonthTableViewCell.h"
#import "MyDefine.h"

#define IOS_SCREEN_WIDTH    ([ [ UIScreen mainScreen ] bounds ].size.width)

@implementation CalendarMonthTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initComponents];
    }
    return self;
}

// 设置 Model
- (void)setMonthDataModel:(CalendarMonthDataModel *)monthDataModel
{
    self._monthDataModel = monthDataModel;
    [self refreshComponents];
}

// 更新元素信息
- (void)refreshComponents {
    _labelMonth.text = _arrayMonthTitle[self._monthDataModel._month - 1];
    
    for (NSInteger i = 0, day = 1; i < 6 * 7; i++) {
        CalendarDayCellView *dayCellView = _arrayDayCell[i];
        
        if (i >= self._monthDataModel._firstWeekDay - 1 && i < self._monthDataModel._firstWeekDay + self._monthDataModel._daysOfMonth - 1)
        {
            dayCellView.hidden = NO;
            dayCellView.delegate = self;
            
            CalendarDateDataModel *dateDataModel = [self._monthDataModel._arrayDateDataModel objectAtIndex:(day - 1)];
            day++;
            
            [dayCellView setDateDataModel:dateDataModel];
        }
        else
        {
            dayCellView.hidden = YES;
            dayCellView.delegate = nil;
        }
    }
    
    
    for (NSInteger i = 0; i < 6; i++)
    {
        UIView *view = [_arrayLine objectAtIndex:i];
        if (i < self._monthDataModel._calendarLines)
        {
            view.hidden = NO;
        }
        else
        {
            view.hidden = YES;
        }
    }
}

// 初始化元素
- (void)initComponents
{
    _wCell = IOS_SCREEN_WIDTH;
    _hCellLine = 50;
    
    _yMarginLabelMonth = 13;
    _hLabelMonth = 24;
    _wLabelMonth = 70;
    
    _wDayCellView = IOS_SCREEN_WIDTH/7;
    _hDayCellView = 35 + 5;
    _xMarginDayCellView = 0;
    _yMarginDayCellView = 3.5;
    _xGapDayCellView = 0;
    
    _hLine = 0.5;
    _colorLine = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
//    _colorLabelMonth = [UIColor colorWithRed:0 green:0.47 blue:0.98 alpha:1.0];
    _colorLabelMonth = [UIColor blackColor];
    _fontLabelMonth = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    
    _labelMonth = [[UILabel alloc] initWithFrame:CGRectMake(0, _yMarginLabelMonth, IOS_SCREEN_WIDTH, _hLabelMonth)];

    _labelMonth.text = @"";
    _labelMonth.textAlignment = NSTextAlignmentCenter;
    _labelMonth.textColor = _colorLabelMonth;
    [self addSubview:_labelMonth];
    
    CGRect viewFrame = CGRectMake(_xMarginDayCellView, _yMarginDayCellView + _hCellLine, _wDayCellView, _hDayCellView);
    
    _arrayDayCell = [[NSMutableArray alloc] initWithCapacity:6 * 7];
    _arrayLine = [[NSMutableArray alloc] initWithCapacity:6];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //显示中文月
    _arrayMonthTitle = @[[NSString stringWithFormat:@"1%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH)],
                         [NSString stringWithFormat:@"2%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH)],
                         [NSString stringWithFormat:@"3%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH)],
                         [NSString stringWithFormat:@"4%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH)],
                         [NSString stringWithFormat:@"5%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH)],
                         [NSString stringWithFormat:@"6%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH)],
                         [NSString stringWithFormat:@"7%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH)],
                         [NSString stringWithFormat:@"8%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH)],
                         [NSString stringWithFormat:@"9%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH)],
                         [NSString stringWithFormat:@"10%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH)],
                         [NSString stringWithFormat:@"11%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH)],
                         [NSString stringWithFormat:@"12%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH)]];
    
    
    for (NSInteger i = 0; i < 6; i++)
    {
        for (NSInteger j = 0; j < 7; j++)
        {
            CalendarDayCellView *dayCellView = [[CalendarDayCellView alloc] initWithFrame:viewFrame];
            dayCellView.hidden = YES;
            [_arrayDayCell addObject:dayCellView];
            [self addSubview:dayCellView];
            viewFrame.origin.x += _wDayCellView + _xGapDayCellView;
        }
        // 画线
        viewFrame.origin.x = 12.5;
        viewFrame.origin.y += _hDayCellView + _yMarginDayCellView - _hLine;
        viewFrame.size.height = _hLine;
        viewFrame.size.width = _wCell - 25;
        
        UIView *viewLine = [[UIView alloc] initWithFrame:viewFrame];
        viewLine.backgroundColor = _colorLine;
        viewLine.hidden = YES;
        [self addSubview:viewLine];
        [_arrayLine addObject:viewLine];
        
        viewFrame.origin.x = _xMarginDayCellView;
        viewFrame.origin.y += _yMarginDayCellView;
        viewFrame.size.width = _wDayCellView;
        viewFrame.size.height = _hDayCellView;
    }
}

#pragma mark - CalendarDayCellViewDelegate

- (void)CalendarDayCellViewDelegateCallBack_ButtonClickedWithDateDataModel:(CalendarDateDataModel *)dateDataModel
{
//    NSLog(@"clicked");
    // 需要 VC 去判断再自己去获取数据
    
    if ([self.delegate respondsToSelector:@selector(CalendarMonthTableViewCellDelegateCallBack_DayCellClickedWithCalendarMonthDataModel:calendarDateDataModel: Cell:)])
    {
        [self.delegate CalendarMonthTableViewCellDelegateCallBack_DayCellClickedWithCalendarMonthDataModel:self._monthDataModel calendarDateDataModel:dateDataModel Cell:self];
    }
}

@end
