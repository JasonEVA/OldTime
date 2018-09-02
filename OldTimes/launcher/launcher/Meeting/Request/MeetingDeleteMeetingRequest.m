//
//  MeetingDeleteMeetingRequest.m
//  launcher
//
//  Created by Conan Ma on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingDeleteMeetingRequest.h"
static NSString *const SHOW_ID  = @"SHOW_ID";
static NSString *const Event_initialStartTime = @"initialStartTime";
static NSString *const saveType = @"saveType";

@implementation MeetingDeleteMeetingRequest
- (void)deleteSheduleByShowId:(NSString *)showId InitialStartTime:(long long)initialStartTime SaveType:(NSInteger)savetype
{
    self.params[SHOW_ID] = showId;
    self.params[Event_initialStartTime] = @(initialStartTime);
    self.params[saveType] = @(savetype);
    
    [self requestData];
}

- (NSString *)api {
    return @"/Schedule-Module/Meeting";
}

- (NSString *)type {
    return @"DELETE";
}

- (BaseResponse *)prepareResponse:(id)data
{
    MeetingDeleteMeetingResponse *response = [MeetingDeleteMeetingResponse new];
    return response;
}
@end

@implementation MeetingDeleteMeetingResponse

@end