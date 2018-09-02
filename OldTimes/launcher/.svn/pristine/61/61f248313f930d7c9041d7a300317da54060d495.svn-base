//
//  CalendarWeekDataModel.h
//  launcher
//
//  Created by Conan Ma on 15/8/4.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarWeekDataModel : NSObject
@property (nonatomic, strong) NSMutableArray *arrDayModels;
@property (nonatomic, strong) NSCalendar *_calendar;  // 用于整个对象的 calendar 实例
@property (nonatomic, strong) NSDate *FirstDayDataInCurrentWeek;    //当前周的第一天
@property (nonatomic, strong) NSDate *DateBefore;         //存目前获取到的之前的date
@property (nonatomic, strong) NSDate *DateAfter;          //存目前获取到的之后的date
@property (nonatomic) NSInteger year;             // 年
@property (nonatomic) NSInteger WeekOfYear;       // 一年的第几周
- (instancetype)initWithCurrentWeek:(BOOL)isCurrentWeek;

@end
