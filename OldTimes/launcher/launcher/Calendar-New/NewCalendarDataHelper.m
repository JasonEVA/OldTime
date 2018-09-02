//
//  NewCalendarDataHelper.m
//  launcher
//
//  Created by kylehe on 16/3/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarDataHelper.h"
#import "NSDate+CalendarTool.h"
#import "NewCalendarMonthDataModel.h"
#import "NewCalendarWeeksEventRequest.h"

@interface NewCalendarDataHelper ()

//年份 加上部分
@property(nonatomic, assign) NSInteger  addCount;
//年份 减去部分
@property(nonatomic, assign) NSInteger  minusCount;
@end

@implementation NewCalendarDataHelper

+ (NewCalendarDataHelper *)shareInstace
{
    static NewCalendarDataHelper *instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [[self alloc] init];
    });
    return instace;
}

#pragma mark - interfaceMethod －－ 事件部分
- (void)getDateWithStartTime:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NewCalendarWeeksEventRequest *request = [[NewCalendarWeeksEventRequest alloc] initWithDelegate:self];
}

#pragma mark - interfaceMethod - 日历编号部分

#warning  －－这种做法可能有误 －－ NSGregorianCalendar

/**
 *  获取当前时间所在年份的dateModel
 */
- (NSMutableArray *)getCurrentDateModel
{
    if (!self.modelArray.count)
    {
        for (int i = 1 ; i<=12; i ++)
        {
            
            NSDateComponents *comps = [[NSDateComponents alloc]init];
            [comps setMonth:i];
            [comps setDay:1];
            [comps setYear:[NSDate mtc_year:[NSDate date]]];
            NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
            NSDate *date = [calendar dateFromComponents:comps];
            
            [self.modelArray addObject:[self getCalendarDataModelWithDate:date]];
        }
    }
    return self.modelArray;
}

/**
 *  获取上一年的modelArray
 */
- (NSMutableArray *)getLastYearDataModelArray
{
    self.minusCount++;
    
    for (int i = 12 ; i>=1; i --)
    {
        NSDateComponents *comps = [[NSDateComponents alloc]init];
        [comps setMonth:i];
        [comps setDay:1];
        [comps setYear:[NSDate mtc_year:[NSDate date]] - self.minusCount];
        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *date = [calendar dateFromComponents:comps];
        [self.modelArray insertObject:[self getCalendarDataModelWithDate:date] atIndex:0];
    }
    return self.modelArray;
}

/**
 *  获取下一年的modelArray
 */
- (NSMutableArray *)getNextYearDataModelArray
{
    self.addCount ++;
    
    for (int i = 1 ; i<=12; i ++)
    {
        NSDateComponents *comps = [[NSDateComponents alloc]init];
        [comps setMonth:i];
        [comps setDay:1];
        [comps setYear:[NSDate mtc_year:[NSDate date]] + self.addCount];
        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *date = [calendar dateFromComponents:comps];
        
        [self.modelArray addObject:[self getCalendarDataModelWithDate:date]];
    }
    return self.modelArray;
}

#pragma mark - privateMethod
/**
 *  传入当月的某一天，返回当月的所有数据模型
 *
 *  @param date 传入当月的某一天
 *
 *  @return 当月的所有数据模型
 */
- (NSMutableArray *)getCalendarDataModelWithDate:(NSDate *)date
{
    NSMutableArray *tempArray = [NSMutableArray array];
    
    //总共的天数
    NSInteger totalCount = [NSDate mtc_totalDaysInMonth:date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    
    //这个月的第一天
    NSDate *firstDateInMonth = [calendar dateFromComponents:comp];
    
    for (int i = 0 ; i<totalCount; i++)
    {
        NSDate *date = [firstDateInMonth dateByAddingTimeInterval:24*60*60*i];
        
        NewCalendarMonthDataModel *model = [[NewCalendarMonthDataModel alloc] initWithDate:date];
        [tempArray addObject:model];
    }
    return tempArray;
}

#pragma mark - setterAndGetter
- (NSMutableArray *)modelArray
{
    if (!_modelArray)
    {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

@end
