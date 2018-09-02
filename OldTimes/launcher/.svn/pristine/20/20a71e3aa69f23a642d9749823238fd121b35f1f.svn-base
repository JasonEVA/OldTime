//
//  NewApplyFormTimeModel.h
//  launcher
//
//  Created by williamzhang on 16/4/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyFormBaseModel.h"

static NSString *const NewForm_startTime = @"startTime";
static NSString *const NewForm_endTime = @"endTime";
static NSString *const NewForm_isTimeSlotAllDay = @"isTimeSlotAllDay";

@interface NewApplyFormTimeModel : NewApplyFormBaseModel

/**
 *  是否为全天模式
 *
 *  2个时间的时分秒都为0时为全天
 *
 */
+ (BOOL)isAllDayWithStartTime:(NSDate *)startDate endTime:(NSDate *)endDate;

@end
