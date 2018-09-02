//
//  NewCalendarDataHelper.h
//  launcher
//
//  Created by kylehe on 16/3/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  处理日历数据

#import <Foundation/Foundation.h>

@interface NewCalendarDataHelper : NSObject


/**
 *  获得当前年份的ModelArray
 */
- (NSMutableArray *)getCurrentDateModel;
/**
 *  获取上一年份的ModelArray
 */
- (NSMutableArray *)getLastYearDataModelArray;
/**
 *  获取下一年份的ModelArray
 */
- (NSMutableArray *)getNextYearDataModelArray;


+ (NewCalendarDataHelper *)shareInstace;

@property(nonatomic, strong) NSMutableArray  *modelArray;

@end
