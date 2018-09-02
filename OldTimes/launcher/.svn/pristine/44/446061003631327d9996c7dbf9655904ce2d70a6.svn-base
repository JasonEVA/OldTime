//
//  NewApplyFormTimeModel.m
//  launcher
//
//  Created by williamzhang on 16/4/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyFormTimeModel.h"
#import "NSDictionary+SafeManager.h"
#import <DateTools/DateTools.h>

@implementation NewApplyFormTimeModel

+ (BOOL)isAllDayWithStartTime:(NSDate *)startDate endTime:(NSDate *)endDate {
    return startDate.hour == 0 &&
           startDate.minute == 0 &&
           startDate.second == 0 &&
           endDate.hour == 0 &&
           endDate.minute == 0 &&
           endDate.second == 0
    ;
}

- (NSString *)handleInputType:(NSDictionary *)dict {
    NSString *inputType = [super handleInputType:dict];
    NSString *trueType = [dict valueStringForKey:@"timeType"];
    
    if ([trueType isEqualToString:@"TimeSlot"]) {
        self.inputType = Form_inputType_timeSlot;
    }
    else if ([trueType isEqualToString:@"TimePoint"]) {
        self.inputType = Form_inputType_timePoint;
    }
    
    return inputType;
}

- (id)formDataValue {
    if (self.inputType == Form_inputType_timePoint) {
        long long timeInterval = [self.try_inputDetail timeIntervalSince1970] * 1000;
        if (timeInterval == 0) {
            return nil;
        }
        return [NSNumber numberWithLongLong:timeInterval];
    }
    
    long long startTimeInterval = [self.try_inputDetail[NewForm_startTime] timeIntervalSince1970] * 1000;
    long long endTimeInterval = [self.try_inputDetail[NewForm_endTime] timeIntervalSince1970] * 1000;
    BOOL  isTimeLoftAllDay = [self.try_inputDetail valueBoolForKey:NewForm_isTimeSlotAllDay];
    if (startTimeInterval == 0) {
        return nil;
    }
    return @{NewForm_startTime:startTimeInterval > 0?@(startTimeInterval):[NSNull null], NewForm_endTime:endTimeInterval> 0?@(endTimeInterval):[NSNull null],NewForm_isTimeSlotAllDay:[NSNumber numberWithInteger:isTimeLoftAllDay]};
}

@end
