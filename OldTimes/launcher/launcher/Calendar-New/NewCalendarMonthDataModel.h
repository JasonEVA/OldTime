//
//  MewCalendarMonthDataModel.h
//  launcher
//
//  Created by kylehe on 16/3/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewCalendarMonthDataModel : NSObject

@property(nonatomic, assign) NSInteger  year;           // 年

@property(nonatomic, assign) NSInteger  month;          //月

@property(nonatomic, assign) NSInteger  day;            //日

@property(nonatomic, assign) BOOL  isSelected;          //是否被选中

@property(nonatomic, strong) NSDate  *date;             //当前的时间date

@property(nonatomic, strong) NSArray  *eventList;       //事件列表 －－ 待定

@property(nonatomic, assign) NSInteger  totalDays;      //总天数

@property(nonatomic, assign) NSInteger  lines;

@property(nonatomic, assign) NSInteger  firstWeekDay;

@property (nonatomic,strong) NSDate * startDate;
@property (nonatomic,strong) NSDate * endDate;
@property (nonatomic,strong) NSMutableArray * calendarArray ;

@property (nonatomic,assign) NSInteger  serialNumber; // 序号 0-6
@property (nonatomic,assign) NSUInteger  showCount ; // 显示的数量 1-3


- (instancetype)initWithDate:(NSDate *)date;
- (void)addModel:(id)model;
- (void)calendarRank;
- (void)removeCalendarArray;

@end
