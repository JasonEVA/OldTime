//
//  CalendarNewRequest.h
//  launcher
//
//  Created by William Zhang on 15/8/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  新建日历Request

#import "BaseRequest.h"

@class CalendarLaunchrModel;

@interface CalendarNewResponse : BaseResponse

@property (nonatomic, strong) NSArray *startTime;
/** 各个时间点的showId */
@property (nonatomic, strong) NSArray  *showIds;
/** 总领的showId */
@property (nonatomic, copy) NSString *showId;

@property (nonatomic, strong) NSString *relateId;

@end

@interface CalendarNewRequest : BaseRequest

- (void)newCalendarModel:(CalendarLaunchrModel *)model;

@end
