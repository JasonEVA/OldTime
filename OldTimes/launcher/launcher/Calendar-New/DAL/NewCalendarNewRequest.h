//
//  NewCalendarNewRequest.h
//  launcher
//
//  Created by 马晓波 on 16/3/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@class CalendarLaunchrModel;

@interface NewCalendarNewResponse : BaseResponse

@property (nonatomic, strong) NSArray *startTime;
/** 各个时间点的showId */
@property (nonatomic, strong) NSArray  *showIds;
/** 总领的showId */
@property (nonatomic, copy) NSString *showId;

@property (nonatomic, strong) NSString *relateId;

@end

@interface NewCalendarNewRequest : BaseRequest

- (void)newCalendarModel:(CalendarLaunchrModel *)model;

@end
