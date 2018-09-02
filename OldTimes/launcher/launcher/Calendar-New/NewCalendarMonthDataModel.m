                 //
//  MewCalendarMonthDataModel.m
//  launcher
//
//  Created by kylehe on 16/3/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarMonthDataModel.h"
#import "NSDate+CalendarTool.h"
#import "DateTools.h"
#import "NewCalendarWeeksModel.h"

@interface NewCalendarMonthDataModel ()

@property (nonatomic,strong) NSMutableArray * allDayArray ;
@property (nonatomic,strong) NSMutableArray * notAllDayArray;

@end

@implementation NewCalendarMonthDataModel

- (instancetype)initWithDate:(NSDate *)date
{
    if (self = [super init])
    {
        self.day = [NSDate mtc_day:date];
        self.month = [NSDate mtc_month:date];
        self.year = [NSDate mtc_year:date];
        self.totalDays = [NSDate mtc_totalDaysInMonth:date];
        self.date = date;
        self.lines = [self getCalendarLines:[NSDate mtc_firstWeekdayInThisMonth:self.date] daysOfMonth:[self totalDays]];
        self.firstWeekDay = [NSDate mtc_firstWeekdayInThisMonth:date];
    }
    return self;
}

- (NSDate *)startDate
{
    if (!_startDate) {
        _startDate = [NSDate dateWithYear:self.date.year month:self.date.month day:self.date.day hour:0 minute:0 second:0];
    }
    return _startDate;
}
- (NSDate *)endDate
{
    if (!_endDate) {
        _endDate = [NSDate dateWithYear:self.date.year month:self.date.month day:self.date.day hour:23 minute:59 second:59];
    }
    return _endDate;
}
- (NSMutableArray *)allDayArray
{
    if (!_allDayArray) {
        _allDayArray = [NSMutableArray array];
    }
    return _allDayArray;
}
- (NSMutableArray *)notAllDayArray
{
    if (!_notAllDayArray) {
        _notAllDayArray = [NSMutableArray array];
    }
    return _notAllDayArray;
}
- (NSMutableArray *)calendarArray
{
    if (!_calendarArray) {
        _calendarArray = [NSMutableArray array];
    }
    return _calendarArray;
}

- (void)removeCalendarArray
{
    [self.calendarArray removeAllObjects];
    [self.allDayArray removeAllObjects];
    [self.notAllDayArray removeAllObjects];
    self.showCount = 0;
}

- (void)addModel:(id)model
{
    NewCalendarWeeksModel * weekModel = (NewCalendarWeeksModel *)model;
    if (weekModel.isAllDay) {
        [self.allDayArray addObject:weekModel];
    }else {
        [self.notAllDayArray addObject:weekModel];
    }
}

- (void)calendarRank
{
    //首先添加排序后的全天事件
    if (self.allDayArray.count) {
        [self.calendarArray addObjectsFromArray:[self rank:self.allDayArray]];
    }
    //其次添加排序后的非全天事件
    if (self.notAllDayArray.count) {
        [self.calendarArray addObjectsFromArray:[self rank:self.notAllDayArray]];
    }
}

/// 未使用: 新增的日程事件排序方式,先按开始时间前>后,再按持续时间长>短
- (NSMutableArray *)sortEventsWithDurationAndStartTime:(NSMutableArray *)array {
	NSSortDescriptor *startTimeDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:YES];
	NSSortDescriptor *durationDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"scheduleDuration" ascending:NO];
	
	return [NSMutableArray arrayWithArray:[array sortedArrayUsingDescriptors:@[startTimeDescriptor,durationDescriptor]]];
}

- (NSMutableArray *)rank:(NSMutableArray *)array
{
    NSInteger num = [array count];
    for(int i = 0 ; i < num-1 ; i++)
    {
        for(int j = i +1; j < num ; j++)
        {
            NewCalendarWeeksModel * model1 = [array objectAtIndex:i];
            NewCalendarWeeksModel * model2 = [array objectAtIndex:j];
            
//            if (model1.startTime > model2.startTime) { // 1 的开始时间晚于2的,把2排到前面
//                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
//            }
            
            NSTimeInterval duration1 = model1.endTime - model1.startTime;
            NSTimeInterval duration2 = model2.endTime - model2.startTime;
            if (duration1 <= duration2) {
                [array exchangeObjectAtIndex:j withObjectAtIndex:i];
            }
            
//            NewCalendarWeeksModel *model1= [array objectAtIndex:i];
//            NewCalendarWeeksModel *model2= [array objectAtIndex:j];
//            long long  interval1 = model1.endTime - model1.startTime;
//            long long  interval2 = model2.endTime - model2.startTime;// 获取时间间隔
//            interval1 = interval1 /1000;
//            // 转化成秒
//            float day1 = interval1/ (24*60*60.0);
//            interval2 = interval2/1000;
//            // 转化成秒
//            float day2 = interval2/ (24*60*60.0);
//            if (day1<day2) {
//               [array exchangeObjectAtIndex:i withObjectAtIndex:j];
//                
//            }else if(day1==day2){
//                 [array exchangeObjectAtIndex:i withObjectAtIndex:j];
//                
//            }
            
        }
    }
    return array;
}



// 得到当月月历有几行
- (NSInteger)getCalendarLines:(NSInteger)firstWeekDay daysOfMonth:(NSInteger)daysOfMonth
{
    NSInteger lines;
    
    lines = (firstWeekDay  + 1 + daysOfMonth - 2) / 7 + 1;
    
    return lines;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%p, %@, %@", self, [self class], @{
                                                                           @"year": @(self.year),
                                                                           @"month":@(self.month),
                                                                           @"day": @(self.day),
                                                                           @"startDate": self.startDate,
                                                                           @"endDate": self.endDate,
                                                                           @"calendarArray": self.calendarArray,
                                                                           @"totalCount": @(self.totalDays)
                                                                           }];
}

@end
