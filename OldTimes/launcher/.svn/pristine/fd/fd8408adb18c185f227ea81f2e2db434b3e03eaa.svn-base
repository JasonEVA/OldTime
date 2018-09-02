//
//  CalendarDeleteRequest.m
//  launcher
//
//  Created by Kyle He on 15/8/20.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarDeleteRequest.h"

static NSString *const c_scheduleId  = @"showId";
static NSString *const c_relateId = @"relateId";
static NSString *const Event_initialStartTime = @"initialStartTime";
static NSString *const saveType = @"saveType";

@implementation CalendarDeleteResponse

@end

@implementation CalendarDeleteRequest

- (void)deleteSheduleByShowId:(NSString *)showId initialStartTime:(NSDate *)initialStartTime saveType:(NSInteger)savetype
{
    self.params[c_scheduleId] = showId;
    self.params[Event_initialStartTime] = @([initialStartTime timeIntervalSince1970] * 1000);
    self.params[saveType] = @(savetype);
    
    [self requestData];
}

- (void)deleteSheduleByRelateId:(NSString *)relateId initialStartTime:(NSDate *)initialStartTime saveType:(NSInteger)savetype
{
    self.params[c_relateId] = relateId;
    self.params[Event_initialStartTime] = @([initialStartTime timeIntervalSince1970] * 1000);
    self.params[saveType] = @(savetype);
    
    [self requestData];
}

- (NSString *)api {
    return @"/Schedule-Module/Schedule";
}

- (NSString *)type {
    return @"DELETE";
}

- (BaseResponse *)prepareResponse:(id)data {
    CalendarDeleteResponse *response = [CalendarDeleteResponse new];
    response.isNeedEdit = [[((NSDictionary *)data) valueForKey:@"isNeedEdit"] integerValue];
    return  response;
}


@end
