//
//  CalendarMonthDataModel.m
//  Titans
//
//  Created by Wythe Zhou on 10/29/14.
//  Copyright (c) 2014 Remon Lv. All rights reserved.
//

#import "CalendarMonthDataModel.h"
#import "CalendarDateDataModel.h"
#import <DateTools/DateTools.h>

@implementation CalendarMonthDataModel

- (instancetype)initWithYear:(NSInteger)year month:(NSInteger)month
{
    if (self = [super init]) {
        [self setComponentsWithYear:year month:month];
    }
    return self;
}

- (instancetype)initWithCurrentMonth
{
    if (self = [super init]) {
        self._calendar = [NSCalendar currentCalendar];
        NSDate *date = [NSDate date];
        NSDateComponents *dateComponents = [self._calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
        NSInteger year = dateComponents.year;
        NSInteger month = dateComponents.month;
        [self setComponentsWithYear:year month:month];
    }
    return self;
}

- (void)setComponentsWithYear:(NSInteger)year month:(NSInteger)month
{
    self._year = year;
    self._month = month;
    if (self._calendar == nil)
    {
        self._calendar = [NSCalendar currentCalendar];
    }
    self._firstDateInThisMonth = [self getFirstDateInMonth:month year:year];
    
    NSDateComponents *dateComponents = [self._calendar components:NSCalendarUnitWeekday fromDate:self._firstDateInThisMonth];
    
    self._firstWeekDay = dateComponents.weekday;
    self._daysOfMonth = [self numberOfDaysInMonth:month year:year];
    
    self._calendarLines = [self getCalendarLines:self._firstWeekDay daysOfMonth:self._daysOfMonth];
    self._cellHeight = 55 * (self._calendarLines + 1);
    
    // 初始化月中每天的 Model
    self._arrayDateDataModel = [[NSMutableArray alloc] initWithCapacity:self._daysOfMonth];
    
    for (int day = 1; day <= self._daysOfMonth; day++) {
        CalendarDateDataModel *dateDataModel = [[CalendarDateDataModel alloc] init];
        DayModel *dayModel = [[DayModel alloc] init];
        dayModel._dayNumber = day;
        [dateDataModel setYear:self._year month:self._month day:dayModel];
        [self._arrayDateDataModel setObject:dateDataModel atIndexedSubscript:day - 1];
    }
}

#pragma mark - Help Methods

// 得到第一天
- (NSDate *)getFirstDateInMonth:(NSInteger)month year:(NSInteger)year
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    [dateComponents setYear:year];
    [dateComponents setMonth:month];
    [dateComponents setDay:1];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    
    return date;
}

// 得到当月月历有几行
- (NSInteger)getCalendarLines:(NSInteger)firstWeekDay daysOfMonth:(NSInteger)daysOfMonth
{
    NSInteger lines;
    
    lines = (firstWeekDay  + daysOfMonth - 2) / 7 + 1;
    
    return lines;
}


// 判断是否是闰年
- (BOOL)isLeapYear:(NSInteger)year
{
    NSAssert(!(year < 1), @"invalid year number");
    BOOL leap = FALSE;
    if ((0 == (year % 400))) {
        leap = TRUE;
    }
    else if((0 == (year%4)) && (0 != (year % 100))) {
        leap = TRUE;
    }
    return leap;
}

- (NSInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger)year
{
    NSAssert(!(month < 1||month > 12), @"invalid month number");
    NSAssert(!(year < 1), @"invalid year number");
    month = month - 1;
    static int daysOfMonth[12] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    NSInteger days = daysOfMonth[month];
    
    // feb
    if (month == 1) {
        if ([self isLeapYear:year]) {
            days = 29;
        }
        else {
            days = 28;
        }
    }
    return days;
}

// 得到上一月
- (CalendarMonthDataModel *)getLastMonth
{
    NSInteger year, month;
    
    month = self._month;
    year = self._year;
    
    if (month == 1)
    {
        month = 12;
        year--;
    }
    else
    {
        month--;
    }
    CalendarMonthDataModel *lastMonth = [[CalendarMonthDataModel alloc] initWithYear:year month:month];
    return lastMonth;
}

// 得到下一月
- (CalendarMonthDataModel *)getNextMonth
{
    NSInteger year, month;
    
    month = self._month;
    year = self._year;
    
    if (month == 12)
    {
        month = 1;
        year++;
    }
    else
    {
        month++;
    }
    CalendarMonthDataModel *nextMonth = [[CalendarMonthDataModel alloc] initWithYear:year month:month];
    
    return nextMonth;
}



@end
