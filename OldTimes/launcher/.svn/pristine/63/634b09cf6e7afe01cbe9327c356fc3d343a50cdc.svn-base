//
//  NewGetMeetingDetailRequest.m
//  launcher
//
//  Created by TabLiu on 16/3/9.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewGetMeetingDetailRequest.h"

static NSString *const d_show_ID = @"SHOW_ID";
static NSString *const d_fact_start_time = @"FACT_START_TIME";
static NSString *const d_isCheckMeetingAttender = @"isCheckMeetingAttender";

@implementation NewGetMeetingDetailRequest

- (void)getMeetingDetailWithShowID:(NSString *)showID startTime:(long long)startTime {
	[self getMeetingDetailWithShowID:showID startTime:startTime needCheckAttend:NO];
}

- (void)getMeetingDetailWithShowID:(NSString *)showID startTime:(long long)startTime needCheckAttend:(BOOL)needCheck {
	self.params[d_show_ID] = showID;
	self.params[d_isCheckMeetingAttender] = @(needCheck);
	[self requestData];
	
}

- (NSString *)api {
    return @"/Schedule-Module/Meeting";
}

- (NSString *)type {
    return @"GET";
}

- (BaseResponse *)prepareResponse:(id)data {
    NewGetMeetingDetailResponse *response = [NewGetMeetingDetailResponse new];
    
    
    if ([data isKindOfClass:[NSDictionary class]]) {
        NewMeetingModel *model = [[NewMeetingModel alloc] initWithDict:data];
        response.model = model;
    }

    return response;
}


@end

@implementation NewGetMeetingDetailResponse

@end