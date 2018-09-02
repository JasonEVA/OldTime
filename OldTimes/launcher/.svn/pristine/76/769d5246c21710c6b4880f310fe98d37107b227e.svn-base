//
//  GetMeetingDetailRequest.m
//  launcher
//
//  Created by Andrew Shen on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "GetMeetingDetailRequest.h"

static NSString *const d_show_ID = @"SHOW_ID";
static NSString *const d_fact_start_time = @"FACT_START_TIME";

@implementation GetMeetingDetailResponse
@end

@implementation GetMeetingDetailRequest

- (void)getMeetingDetailWithShowID:(NSString *)showID startTime:(NSDate *)startTime {
    self.params[d_show_ID] = showID;

    long long startInterval = [startTime timeIntervalSince1970] * 1000;
    if (startInterval != 0) {
        self.params[d_fact_start_time] = [NSNumber numberWithLongLong:startInterval];
    }
    
    [self requestData];
}

- (NSString *)api {
    return @"/Schedule-Module/Meeting";
}

- (NSString *)type {
    return @"GET";
}

- (BaseResponse *)prepareResponse:(id)data {
    GetMeetingDetailResponse *response = [GetMeetingDetailResponse new];
    if ([data isKindOfClass:[NSDictionary class]]) {
        NewMeetingModel *model = [[NewMeetingModel alloc] initWithDict:data];
        response.meetingModel = model;
    }
    return response;
}
@end