//
//  NewCalendarGetRequest.m
//  launcher
//
//  Created by TabLiu on 16/3/9.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarGetRequest.h"

static NSString *const d_showId           = @"showId";
static NSString *const d_initialStartTime = @"initialStartTime";

@implementation NewCalendarGetRequest

- (void)getCalendarWithShowId:(NSString *)showId initialStartTime:(long long)initialStartTime
{
    [self.params setValue:showId forKey:d_showId];
    [self.params setValue:@(initialStartTime) forKey:d_initialStartTime];
    [self requestData];
}

- (NSString *)api  { return @"/Schedule-Module/Schedule"; }
- (NSString *)type { return @"GET"; }

- (BaseResponse *)prepareResponse:(id)data
{
    NewCalendarGetResponse *response = [NewCalendarGetResponse new];
    response.model = [[CalendarLaunchrModel alloc] initWithDict:data];
    return response;
}

@end

@implementation NewCalendarGetResponse

@end