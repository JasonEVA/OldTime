//
//  NewCalendarEditRequest.h
//  launcher
//
//  Created by 马晓波 on 16/3/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@class CalendarLaunchrModel;

@interface NewCalendarEditResponse : BaseResponse
@property (nonatomic, copy) NSString *showIdNew;

/** 各个时间点的showId */
@property (nonatomic, strong) NSArray  *showIds;

@property (nonatomic, strong) NSArray *startTime;
@end


@interface NewCalendarEditRequest : BaseRequest
/** 修改数据类型，修改之前的开始时间 */
- (void)editScheduleByCalendarModel:(CalendarLaunchrModel *)model initialStartTime:(NSString *)initialStartTime WithSaveType:(NSInteger)SaveType;
@end
