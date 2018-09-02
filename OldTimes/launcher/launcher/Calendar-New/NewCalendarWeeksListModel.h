//
//  NewCalendarWeeksListModel.h
//  launcher
//
//  Created by TabLiu on 16/3/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
// 日程 - 周 - 列表 

#import <Foundation/Foundation.h>

@interface NewCalendarWeeksListModel : NSObject

@property (nonatomic,strong) NSString *  NO_Day; // 几月几号
@property (nonatomic,strong) NSString * NO_Weeks; // 周几
@property (nonatomic,strong) NSMutableArray * calendarArray; // 当天的所有日程

@property (nonatomic,strong) NSMutableArray * allDayArray ;
@property (nonatomic,strong) NSMutableArray * notAllDayArray;

@property (nonatomic,strong) NSDate * srartTime;
@property (nonatomic,strong) NSDate * endTime;

- (id)init; // 初始化数组
- (void)setDayAndWeek; // 根据date 计算是几月几号 是周几
- (void)calendarRank;
- (void)addModel:(id)model;

- (NSString *)strDate;

@end
