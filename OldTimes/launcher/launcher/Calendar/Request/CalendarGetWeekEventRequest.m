//
//  CalendarGetWeekEventRequest.m
//  launcher
//
//  Created by Conan Ma on 15/8/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarGetWeekEventRequest.h"
#import "CalendarLaunchrModel.h"

static NSString *const Calendar_Event_startTime = @"startTime";
static NSString *const Calendar_Event_endTime   = @"endTime";
static NSString *const Calendar_Event_user      = @"user";
static NSString *const Calendar_Event_type      = @"type";

@implementation CalendarGetWeekEventResponse

@end

@implementation CalendarGetWeekEventRequest

- (void)eventListWithStartDate:(NSDate *)start endDate:(NSDate *)endDate userLoginName:(NSString *)loginName {
    long long startInterval = [start timeIntervalSince1970] * 1000;
    long long endInterval = [endDate timeIntervalSince1970] * 1000;
    
    self.params[Calendar_Event_startTime] = @(startInterval);
    self.params[Calendar_Event_endTime]   = @(endInterval);
    self.params[Calendar_Event_user]      = loginName ?:@"";
    
    [self requestData];
}

- (NSString *)api { return @"/Schedule-Module/Schedule/GetList";}

- (NSString *)type { return @"GET";}

- (BaseResponse *)prepareResponse:(id)data {
    CalendarGetWeekEventResponse *response = [CalendarGetWeekEventResponse new];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dict in data) {
        if (!dict) {
            continue;
        }
        
        CalendarLaunchrModel *model = [[CalendarLaunchrModel alloc] initWithDayDict:dict];
        [array addObject:model];
    }
    
    response.arrayresult = array;
    return response;
}

@end
