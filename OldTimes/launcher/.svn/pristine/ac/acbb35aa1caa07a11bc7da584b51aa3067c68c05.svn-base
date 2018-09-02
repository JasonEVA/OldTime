//
//  NewCalendarWeeksEventRequest.m
//  launcher
//
//  Created by TabLiu on 16/3/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarWeeksEventRequest.h"
#import "NewCalendarWeeksModel.h"
#import "DateTools.h"

static NSString *const Calendar_Event_startTime = @"startTime";
static NSString *const Calendar_Event_endTime   = @"endTime";
static NSString *const Calendar_Event_user      = @"user";
static NSString *const Calendar_Event_type      = @"type";

@implementation NewCalendarWeeksEventRequest

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
    NewCalendarWeeksEventResponse *response = [NewCalendarWeeksEventResponse new];
    response.dataArray = [NSMutableArray array];
    for (NSDictionary * dic in data) {
        NewCalendarWeeksModel * model = [[NewCalendarWeeksModel alloc] initWithDIC:dic];
        [response.dataArray addObject:model];
    }
    return response;
}

@end

@implementation NewCalendarWeeksEventResponse

@end







