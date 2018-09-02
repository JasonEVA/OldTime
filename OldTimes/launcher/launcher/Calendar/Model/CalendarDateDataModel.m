//
//  CalendarDateDataModel.m
//  Titans
//
//  Created by Wythe Zhou on 10/29/14.
//  Copyright (c) 2014 Remon Lv. All rights reserved.
//

#import "CalendarDateDataModel.h"

@implementation CalendarDateDataModel

- (void)setYear:(NSInteger)year month:(NSInteger)month day:(DayModel *)dayModel
{
    self._year = year;
    self._month = month;
    self._dayModel = dayModel;
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:year];
    [dateComponents setMonth:month];
    [dateComponents setDay:dayModel._dayNumber];

    self._date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    

    dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self._date];
    self._weekday = dateComponents.weekday;
    self._weekends = ((self._weekday == 1) || (self._weekday == 7));        // 判断是不是周末
    
    //判断是否是今天
    dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    if (self._year == dateComponents.year && self._month == dateComponents.month && self._dayModel._dayNumber == dateComponents.day)
    {
        self._ifToday = YES;
    }
    else
    {
        self._ifToday = NO;
    }
}

@end
