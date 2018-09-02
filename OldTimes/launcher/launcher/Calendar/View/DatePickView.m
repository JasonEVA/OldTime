//
//  DatePickView.m
//  launcher
//
//  Created by Conan Ma on 15/8/26.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "DatePickView.h"
#import "DateTools.h"
#import "UnifiedUserInfoManager.h"
#import "NSDate+String.h"

@interface DatePickView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation DatePickView

- (instancetype)init
{
    if (self = [super init])
    {
        [self.arrYearsWithMandD addObjectsFromArray:[self createArray:[NSDate date]]];
        [self setpickviewWithDate:[NSDate date]];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (NSMutableArray *)createArray:(NSDate *)date
{
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

- (NSInteger)todayRowIncomponent
{
    for (NSInteger i = 0; i < self.arrYearsWithMandD.count ; i ++) {
        NSDate *date = [self.arrYearsWithMandD objectAtIndex:i];
        if ([date isToday]) {
            return i;
        }
    }
    return 0;
}

- (void)SetDate:(NSDate *)date
{
    [self setpickviewWithDate:date animated:YES];
}

- (void)setpickviewWithDate:(NSDate *)date
{
    [self setpickviewWithDate:date animated:NO];
}

- (void)setpickviewWithDate:(NSDate *)date animated:(BOOL)animated {
    for (NSInteger i = 0; i < self.arrYearsWithMandD.count ; i ++)
    {
        NSDate *dateTmp = [self.arrYearsWithMandD objectAtIndex:i];
        if (dateTmp.day == date.day && dateTmp.month == date.month && dateTmp.year == date.year)
        {
            [self selectRow:i inComponent:0 animated:animated];
        }
    }
    
    [self selectRow:date.hour + 50 * 24 inComponent:1 animated:animated];
    [self selectRow:date.minute/5 + 50 * 12 inComponent:2 animated:animated];
    self.SelectedDate = date;
}

#pragma mark - UIPickerView Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return self.arrYearsWithMandD.count;
            break;
        case 1:
            return 24*100;
            break;
        case 2:
            return 12*100;
            break;
        default: return 0;
            break;
    }
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            NSDate *date = [self.arrYearsWithMandD objectAtIndex:row];
            if ([date isToday])
            {
                return LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY);
            }
            return [self.dateFormatter stringFromDate:date];
        }
            break;
        case 1:
            return [self.arrHour objectAtIndex:(row%24)];
            break;
        case 2:
            return [self.arrMinute objectAtIndex:(row%12)];
            break;
        default:return @"";
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
{
    switch (component)
    {
        case 0:
            return 165;
            break;
        case 1:
            return (self.frame.size.width - 165 - 10)/2;
            break;
        case 2:
            return (self.frame.size.width - 165 - 10)/2;
            break;
        default: return (self.frame.size.width - 165 - 10)/2;
            break;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDate *selectedDate = self.SelectedDate;
    NSInteger hour = self.SelectedDate.hour;
    NSInteger minute = self.SelectedDate.minute;
    switch (component) {
        case 0:
            selectedDate = [self.arrYearsWithMandD objectAtIndex:row];
            break;
        case 1:
            hour = [[self.arrHour objectAtIndex:(row%24)] integerValue];
            break;
        case 2:
            minute = [[self.arrMinute objectAtIndex:(row%12)] integerValue];
            break;
    }
    
    self.SelectedDate = [NSDate dateWithYear:selectedDate.year month:selectedDate.month day:selectedDate.day hour:hour minute:minute second:0];
    
    if ([self.Valuedelegate respondsToSelector:@selector(getNewDateWhenPickViewValueChanged:)])
    {
        [self.Valuedelegate getNewDateWhenPickViewValueChanged:self.SelectedDate];
    }
}

#pragma mark - init
- (NSMutableArray *)arrHour
{
    if (!_arrHour)
    {
        _arrHour = [[NSMutableArray alloc] init];
        for (int i = 0; i<24; i++)
        {
            [_arrHour addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _arrHour;
}

- (NSMutableArray *)arrMinute
{
    if (!_arrMinute)
    {
        _arrMinute = [[NSMutableArray alloc] init];
        for (int i = 0; i<=55; i = i +5)
        {
            [_arrMinute addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _arrMinute;
}

- (NSMutableArray *)arrYearsWithMandD
{
    if (!_arrYearsWithMandD)
    {
        _arrYearsWithMandD = [self createArray:[[NSDate date] mtc_calculatorMinuteIntervalDidChange:nil]];
    }
    return _arrYearsWithMandD;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:LOCAL(CALENDAR_SCHEDULEBYWEEK_TIMEMODE)];
        _dateFormatter.locale = [[UnifiedUserInfoManager share] getLocaleIdentifier];
    }
    return _dateFormatter;
}

- (NSDate *)SelectedDate
{
    if (!_SelectedDate)
    {
        _SelectedDate = [NSDate date];
    }
    return _SelectedDate;
}
@end
