//
//  DayByDaySelectCalendarView.m
//  OnlyMonthAndDayPicker
//
//  Created by William Zhang on 15/8/4.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "DayByDaySelectCalendarView.h"
#import <Masonry/Masonry.h>
#import <DateTools/DateTools.h>
#import "MyDefine.h"
#import "Category.h"

@interface DayByDaySelectCalendarView () <UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;

/** 存储2排数据 */
@property (nonatomic, strong) NSArray *timeArray;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation DayByDaySelectCalendarView

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    size.height = 216;
    return size;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.pickerView];
        [self resetDate];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - Private Method
/** 查找今天在component中的row */
- (NSInteger)todayRowIncomponent:(NSInteger)component {
    NSArray *array = self.timeArray[component];
    for (NSInteger i = 0; i < array.count ; i ++) {
        NSDate *date = [array objectAtIndex:i];
        if ([date isToday]) {
            return i;
        }
    }
    return 0;
}

- (NSInteger)rowDate:(NSDate *)date inComponent:(NSInteger)component {
    NSArray *array = self.timeArray[component];
    for (NSInteger i = 0; i < array.count ; i ++) {
        NSDate *dateTmp = [array objectAtIndex:i];
        if (dateTmp.day == date.day && dateTmp.month == date.month && dateTmp.year == date.year) {
            return i;
        }
    }
    return 0;
}

#pragma mark - Interface Method
/** 获取选中时间 */
- (NSDate *)selectedDateInComponent:(NSInteger)component {
    if (component > self.timeArray.count) {
        return [NSDate date];
    }
    
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:component];
    return [self.timeArray[component] objectAtIndex:selectedRow];
}

/** 重置回当前时间 */
- (void)resetDate {
    [self.pickerView selectRow:[self todayRowIncomponent:0] inComponent:0 animated:NO];
    [self.pickerView selectRow:[self todayRowIncomponent:1] inComponent:1 animated:NO];
}

- (void)setStartDate:(NSDate *)startDate endData:(NSDate *)endDate {
    [self.pickerView selectRow:[self rowDate:startDate inComponent:0]  inComponent:0 animated:NO];
    [self.pickerView selectRow:[self rowDate:endDate inComponent:1] inComponent:1 animated:NO];
}

#pragma mark - UIPickerView Delegate & DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.timeArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.timeArray[component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDate *date = [self.timeArray[component] objectAtIndex:row];
    if ([date isToday]) {
        return LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY);
    }
    return [self.dateFormatter stringFromDate:date];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDate *firstDate = [self selectedDateInComponent:0];
    NSDate *secondDate = [self selectedDateInComponent:1];
    
    if ([firstDate isLaterThan:secondDate]) {
        // 第一条时间不能比第二条迟
        // 待比较的component
        NSInteger compareComponent = component ? 0 : 1;
        [pickerView selectRow:row inComponent:compareComponent animated:YES];
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Create Array
/** 根据时间创建前半年，后1年 */
- (NSMutableArray *)createArray:(NSDate *)date {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[date copy]];

    for (NSInteger i = 1; i <= 365 / 2; i ++) {
        // 前半年
        NSDate *dateEarly = [date dateByAddingDays:-i];
        [array insertObject:dateEarly atIndex:0];
        
        // 后半年
        NSDate *dateLater = [date dateByAddingDays:i];
        [array addObject:dateLater];
    }
    
    for (NSInteger i = 365 / 2 + 1; i <= 365; i ++) {
        // 后半年再半年
        NSDate *dateLater = [date dateByAddingDays:i];
        [array addObject:dateLater];
    }
    return array;
}

#pragma mark - Initializer
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (NSArray *)timeArray {
    if (!_timeArray) {
        NSMutableArray *firstDaysArray = [self createArray:[[NSDate date] mtc_calculatorMinuteIntervalDidChange:nil]];
        NSMutableArray *secondDaysArray = [self createArray:[[NSDate date] mtc_calculatorMinuteIntervalDidChange:nil]];
        _timeArray = @[firstDaysArray, secondDaysArray];
    }
    return _timeArray;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:LOCAL(CALENDAR_SCHEDULEBYWEEK_TIMEMODE)];
        _dateFormatter.locale = [[UnifiedUserInfoManager share] getLocaleIdentifier];
    }
    return _dateFormatter;
}

@end
