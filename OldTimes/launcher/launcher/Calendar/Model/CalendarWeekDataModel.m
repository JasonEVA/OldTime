//
//  CalendarWeekDataModel.m
//  launcher
//
//  Created by Conan Ma on 15/8/4.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarWeekDataModel.h"
#import "CalendarDateDataModel.h"
#import "DateTools.h"

@implementation CalendarWeekDataModel

- (instancetype)initWithCurrentWeek:(BOOL)isCurrentWeek
{
    if (self = [super init])
    {
        if (isCurrentWeek)
        {
            //            self._calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            self._calendar = [NSCalendar currentCalendar];
            NSDate *date = [NSDate date];
            //            NSDateComponents *dateComponents = [self._calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfYear fromDate:date];
            //            NSInteger year = dateComponents.year;
            //            NSInteger month = dateComponents.month;
            //            NSInteger weekofyear = dateComponents.weekOfYear;
            
            //            [self setComponentsWithYear:year month:month WeekOfYear:weekofyear];
            //            [self getfirstdateinmonth:date];
            [self setComponentsWithYear:date.year month:date.month WeekOfYear:date.weekOfYear];
        }
    }
    return self;
}

- (void)setComponentsWithYear:(NSInteger)year month:(NSInteger)month WeekOfYear:(NSInteger)weekOfYear
{
    if (self._calendar == nil)
    {
        self._calendar = [NSCalendar currentCalendar];
    }
    //    self.FirstDayDataInCurrentWeek = [self getFirstDateInWeekWithMonth:month year:year WeekOfYear:weekOfYear WeekOfDay:1];
    self.FirstDayDataInCurrentWeek = [self getfirstdateinmonth:[NSDate date]];
    
    self.DateAfter = self.FirstDayDataInCurrentWeek;
    self.DateBefore = self.FirstDayDataInCurrentWeek;
    
    for (NSInteger day = 0; day < 7; day++)
    {
        CalendarDateDataModel *dateDataModel = [[CalendarDateDataModel alloc] init];
        //        NSDate *date = [self getFirstDateInWeekWithMonth:month year:year WeekOfYear:self.FirstDayDataInCurrentWeek.weekOfYear WeekOfDay:day];
        NSDate *date = [self.FirstDayDataInCurrentWeek dateByAddingDays:day];
        DayModel *dayModel = [[DayModel alloc] init];
        NSDateComponents *WeekdateComponents = [self._calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
        
        dayModel._dayNumber = WeekdateComponents.day;
        [dateDataModel setYear:WeekdateComponents.year month:WeekdateComponents.month day:dayModel];
        [self.arrDayModels setObject:dateDataModel atIndexedSubscript:day];
    }
}

- (NSDate *)getfirstdateinmonth:(NSDate *)date
{
    NSDate *datetest = [NSDate date];
    for (NSInteger i = 0; i< 7; i++)
    {
        datetest = [datetest dateBySubtractingDays:1];
        if (datetest.weekOfYear != date.weekOfYear)
        {
            datetest = [datetest dateByAddingDays:1];
            NSDate *dateneed = [NSDate dateWithYear:datetest.year month:datetest.month day:datetest.day hour:0 minute:0 second:0];
            return dateneed;
        }
    }
    return datetest;
}

// 得到当前一周的第n天
- (NSDate *)getFirstDateInWeekWithMonth:(NSInteger)month year:(NSInteger)year WeekOfYear:(NSInteger)weekOfYear WeekOfDay:(NSInteger)weekofday
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    [dateComponents setYear:year];
    //    [dateComponents setMonth:month];
    [dateComponents setWeekOfYear:weekOfYear];
    [dateComponents setWeekday:weekofday];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    
    return date;
}

#pragma mark - init
- (NSArray *)arrDayModels
{
    if (!_arrDayModels)
    {
        _arrDayModels = [[NSMutableArray alloc] init];
    }
    return _arrDayModels;
}

- (NSDate *)FirstDayDataInCurrentWeek
{
    if (!_FirstDayDataInCurrentWeek)
    {
        _FirstDayDataInCurrentWeek = [[NSDate alloc] init];
    }
    return _FirstDayDataInCurrentWeek;
}
@end
