//
//  NewCalendarWeeksModel.m
//  launcher
//
//  Created by TabLiu on 16/3/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarWeeksModel.h"
#import "NSDictionary+SafeManager.h"
#import <DateTools.h>

@implementation NewCalendarWeeksModel

- (id)initWithDIC:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _createUser = [dic valueStringForKey:@"createUser"];
        _createUserName = [dic valueStringForKey:@"createUserName"];
        _endTime = [[dic valueStringForKey:@"endTime"] longLongValue];
        _isAllDay = [[dic valueStringForKey:@"isAllDay"] intValue];
        _isAllowSearch = [dic valueBoolForKey:@"isAllowSearch"];
        _isCancel = [[dic valueStringForKey:@"isCancel"] intValue];
        _isImportant = [[dic valueStringForKey:@"isImportant"] intValue];
        _isVisible = [dic valueBoolForKey:@"isVisible"];
        _laty = [dic valueStringForKey:@"laty"];
        _lngx = [dic valueStringForKey:@"lngx"];
        _place = [dic valueStringForKey:@"place"];
        _relateId = [dic valueStringForKey:@"relateId"];
        _repeatType = [[dic valueStringForKey:@"repeatType"] intValue];
        _showId = [dic valueStringForKey:@"showId"];
        _startTime = [[dic valueStringForKey:@"startTime"] longLongValue];
        _title = [dic valueStringForKey:@"title"];
        _type = [dic valueStringForKey:@"type"];
		
		

		if (_isAllDay) {
//			_endTime = _endTime + 23.5*60*60*1000;
			/**
			 *	服务器返回全天事件的endTime特点: 一天的全天事件startTime = endTime; 多天全天的事件endTime少一天,手动添加23.59.59,避免影响月视图的排序
			 */
			NSDate *enddate = [dic valueDateForKey:@"endTime"];
			enddate = [NSDate dateWithYear:enddate.year month:enddate.month day:enddate.day+1];
			enddate = [NSDate dateWithTimeInterval:-1 sinceDate:enddate];
			_endTime = [enddate timeIntervalSince1970] * 1000;
		} else {
			/**
			 * 处理来自Web创建的非全天事件带有秒数的数据,避免影响月视图的排序
			 */
			_endTime = _endTime / 100 / 1000 * 100 * 1000;
			_startTime = _startTime  / 100 / 1000 * 100 * 1000;
			long long num = _endTime - _startTime;
			if (num >= 24*60*60*1000)
			{
				_pretendIsAllDay = YES;
			}
		}
		
		_scheduleDuration = (_endTime - _startTime)/1000;
        
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%p, %@,\r%@", self, [self class], @{
                                                                           @"title": _title,
																		   @"startTim:": @(_startTime/1000),
                                                                           @"duration": @((_endTime - _startTime)/1000),
                                                                           @"type": _type,
                                                                           @"showID": _showId,
																		   @"visible": @(_isVisible)
                                                                           }];
}
@end
