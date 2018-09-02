//
//  MeetingGetListRequest.m
//  launcher
//
//  Created by William Zhang on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingGetListRequest.h"
#import "CalendarLaunchrModel.h"
#import <DateTools.h>

static NSString *const d_user      = @"user";
static NSString *const d_startTime = @"startTime";
static NSString *const d_endTime   = @"endTime";
static NSString *const d_type      = @"type";

@implementation MeetingGetListResponse
@end

@implementation MeetingGetListRequest

- (void)meetingListWithUser:(NSString *)userName startTime:(NSDate *)startTime endTime:(NSDate *)endTime {
    self.params[d_user] = userName ?:@"";
    
    // 转换0:00～23:59
    NSDate *startTimeChanged = [NSDate dateWithYear:startTime.year month:startTime.month day:startTime.day];
    NSDate *endTimeChanged   = [NSDate dateWithYear:endTime.year month:endTime.month day:endTime.day hour:23 minute:59 second:59];
    
    long long startInterval = [startTimeChanged timeIntervalSince1970] * 1000;
    long long endInterval   = [endTimeChanged timeIntervalSince1970] * 1000;
    
    self.params[d_startTime] = @(startInterval);
    self.params[d_endTime]   = @(endInterval);
    
    // 会议必填参数
    //传空获
    self.params[d_type] = @"";
    [self requestData];
}

- (NSString *)api {
    return @"/Schedule-Module/Schedule/GetList";  //@"/Schedule-Module/Schedule/GetUnFreeMeetingListForWeb";
}

- (NSString *)type {
    return @"GET";
}

- (BaseResponse *)prepareResponse:(id)data {
    MeetingGetListResponse *response = [MeetingGetListResponse new];
    
    NSMutableArray *arrayTmp = [NSMutableArray array];
    
    // 特殊data （NSARRAY）
    for (NSDictionary *dict in data) {
        if (!dict) {
            continue;
        }
        
        CalendarLaunchrModel *model = [[CalendarLaunchrModel alloc] initWithDayDict:dict];
        [arrayTmp addObject:model];
    }
    
    response.meetingList = [NSArray arrayWithArray:arrayTmp];
    
    return response;
}

@end
