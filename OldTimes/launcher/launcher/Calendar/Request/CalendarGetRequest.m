//
//  CalendarGetRequest.m
//  launcher
//
//  Created by William Zhang on 15/8/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarGetRequest.h"
#import "CalendarLaunchrModel.h"

static NSString *const d_showId           = @"showId";
static NSString *const d_initialStartTime = @"initialStartTime";

@implementation CalendarGetResponse
@end

@interface CalendarGetRequest ()

@property (nonatomic, strong) CalendarLaunchrModel *model;

@end

@implementation CalendarGetRequest

- (void)getCalendarWithModel:(CalendarLaunchrModel *)model {
    _model = model;
    self.params[d_showId] = model.showId;
    NSDate *date = [model.time firstObject];
    self.params[d_initialStartTime] = @([date timeIntervalSince1970] * 1000);
    [self requestData];
}

- (NSString *)api
{
    return @"/Schedule-Module/Schedule";
}

- (NSString *)type
{
    return @"GET";
}

- (BaseResponse *)prepareResponse:(id)data
{
    CalendarGetResponse *response = [CalendarGetResponse new];
    
    response.modelCalendar = [[CalendarLaunchrModel alloc] initWithDict:data];
    response.modelCalendar.type = self.model.type;
    
    return response;
}

@end
