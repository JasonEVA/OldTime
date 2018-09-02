//
//  CalendarMonthDataModel.h
//  Titans
//
//  Created by Wythe Zhou on 10/29/14.
//  Copyright (c) 2014 Remon Lv. All rights reserved.
//

//  日历的月份数据信息

#import <UIKit/UIKit.h>
#import "MonthModel.h"

@interface CalendarMonthDataModel : NSObject

@property (nonatomic) NSInteger _year;        // 年
@property (nonatomic) NSInteger _month;       // 几月
@property (nonatomic) NSInteger _daysOfMonth;  // 多少天
@property (nonatomic) NSInteger _firstWeekDay;    // 当月第一天是星期几

@property (nonatomic, strong) NSCalendar *_calendar;  // 用于整个对象的 calendar 实例
@property (nonatomic, strong) NSDate *_firstDateInThisMonth;      // 这个月的第一天，时间是 00:00，时区是本地时区

@property (nonatomic) NSInteger _calendarLines;   // 日历的行数
@property (nonatomic) CGFloat _cellHeight;          // 由日历行数计算得到的单元格高度

@property (nonatomic, strong) NSMutableArray *_arrayDateDataModel;      // 月中的日 model

@property (nonatomic, strong) MonthModel *_monthModel;           // 储存的月份信息，那天有事件
// 用年和月初始化
- (instancetype)initWithYear:(NSInteger)year month:(NSInteger)month;

// 用当前时间初始化
- (instancetype)initWithCurrentMonth;

// 配置
- (void)setComponentsWithYear:(NSInteger)year month:(NSInteger)month;

// 得到上一月
- (CalendarMonthDataModel *)getLastMonth;

// 得到下一月
- (CalendarMonthDataModel *)getNextMonth;

@end
