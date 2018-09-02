//
//  CalendarEditRequst.h
//  launcher
//
//  Created by Kyle He on 15/8/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  编辑日程

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@class CalendarLaunchrModel;

@interface CalendarEditResponse : BaseResponse

@property (nonatomic, copy) NSString *showIdNew;

/** 各个时间点的showId */
@property (nonatomic, strong) NSArray  *showIds;

@property (nonatomic, strong) NSArray *startTime;

@end

@interface CalendarEditRequst : BaseRequest

/** 修改数据类型，修改之前的开始时间 */
- (void)editScheduleByCalendarModel:(CalendarLaunchrModel *)model initialStartTime:(NSString *)initialStartTime WithSaveType:(NSInteger)SaveType;

@end
