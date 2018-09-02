//
//  CalendarNewRequest.m
//  launcher
//
//  Created by William Zhang on 15/8/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarNewRequest.h"
#import "NSDictionary+SafeManager.h"
#import "CalendarLaunchrModel.h"
#import <DateTools/DateTools.h>
#import "PlaceModel.h"

static NSString *const  d_title       = @"title";
static NSString *const  d_start       = @"start";
static NSString *const  d_end         = @"end";
static NSString *const  d_type        = @"type";
static NSString *const  d_place       = @"place";
static NSString *const  d_lngx        = @"lngx";
static NSString *const  d_laty        = @"laty";
static NSString *const  d_isImportant = @"isImportant";
static NSString *const  d_isAllDay    = @"isAllDay";
static NSString *const  d_isVisible   = @"isVisible";
static NSString *const  d_content     = @"content";
static NSString *const  d_repeatType  = @"repeatType";
static NSString *const  d_remindType  = @"remindType";

static NSString *const r_times  = @"times";
static NSString *const r_start  = @"start";
static NSString *const r_showId = @"showId";
static NSString *const r_relateId = @"relateId";

@implementation CalendarNewResponse
@end

@implementation CalendarNewRequest

- (void)newCalendarModel:(CalendarLaunchrModel *)model {
    self.params[d_title] = model.try_title;
    [self timeHandle:model.try_time wholeDayMode:model.try_wholeDay];

    self.params[d_place] = model.try_place.name ?: @"";
//    self.params[d_place] = model.address;
    
    CLLocationDegrees lng = model.try_place.coordinate.longitude;
    CLLocationDegrees lat = model.try_place.coordinate.latitude;
    
    self.params[d_lngx] = (lng != MAXLAT ? @(lng) : @"");
    self.params[d_laty] = (lat != MAXLAT ? @(lat) : @"");
    
    self.params[d_isImportant] = [NSNumber numberWithInt:model.try_important];
    self.params[d_isAllDay]    = [NSNumber numberWithInt:model.try_wholeDay];
    self.params[d_content]     = model.try_content?:@"";
    self.params[d_repeatType]  = @(model.try_repeatType);
    self.params[d_remindType]  = @(model.try_remindType);
	self.params[d_isVisible]   = @(model.try_isVisible ? 1 : 0);
    [self requestData];
}

- (NSString *)api {
    return @"/Schedule-Module/Schedule/Save";
}

- (BaseResponse *)prepareResponse:(id)data {
    CalendarNewResponse *response = [CalendarNewResponse new];
    
    NSArray *array = [data valueArrayForKey:r_times];
    
    NSMutableArray *arrayShowId = [NSMutableArray array];
    NSMutableArray *arrayStart  = [NSMutableArray array];
    
    for (NSDictionary *dict in array) {
        NSString *showId = [dict valueStringForKey:r_showId];
        [arrayShowId addObject:showId];
        
        NSNumber *numberStart = [dict valueNumberForKey:r_start];
        [arrayStart addObject:numberStart];
    }
    
    response.startTime = [NSArray arrayWithArray:arrayStart];
    response.showIds   = [NSArray arrayWithArray:arrayShowId];
    response.showId = [data valueStringForKey:r_showId];
    
    response.relateId = [data valueStringForKey:r_relateId];
    
    return response;
}

#pragma mark - Private Method
/** 时间转换成毫秒(分start end 存储) */
- (void)timeHandle:(NSArray *)times wholeDayMode:(BOOL)wholeDay {
    NSMutableArray *startArray = [NSMutableArray array];
    NSMutableArray *endArray = [NSMutableArray array];
    for (NSInteger i = 0; i < [times count]; i += 2) {
    
        NSDate *startDate = times[i];
        NSDate  *endDate  = times[i + 1];
        
        if (wholeDay) {
            // 与服务器设置好的协议
            startDate = [NSDate dateWithYear:startDate.year month:startDate.month day:startDate.day];
            endDate   = [NSDate dateWithYear:endDate.year month:endDate.month day:endDate.day hour:23 minute:59 second:59];
        }
        
        long long start = [startDate timeIntervalSince1970] * 1000;
        long long end   = [endDate timeIntervalSince1970] * 1000;
        [startArray addObject:@(start)];
        [endArray addObject:@(end)];
    }
    
    self.params[d_start] = startArray;
    self.params[d_end]   = endArray;
    
    if ([startArray count] == 1) {
        self.params[d_type] = @"event";
    } else {
        self.params[d_type] = @"event_sure";
    }
}

@end
