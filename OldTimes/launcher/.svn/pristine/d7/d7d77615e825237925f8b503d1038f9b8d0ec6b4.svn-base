//
//  CalendarEditRequst.m
//  launcher
//
//  Created by Kyle He on 15/8/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//
#import "CalendarEditRequst.h"
#import "NSDictionary+SafeManager.h"
#import <DateTools/DateTools.h>
#import "CalendarLaunchrModel.h"
#import "PlaceModel.h"

static NSString *const c_showId           = @"showId";
static NSString *const c_title            = @"title";
static NSString *const c_content          = @"content";
static NSString *const c_type             = @"type";
static NSString *const c_place            = @"place";
static NSString *const c_lngx             = @"lngx";
static NSString *const c_laty             = @"laty";
static NSString *const c_isImportant      = @"isImportant";
static NSString *const c_start            = @"start";
static NSString *const c_end              = @"end";
static NSString *const c_isAllDay         = @"isAllDay";
static NSString *const c_repeatType       = @"repeatType";
static NSString *const c_remindType       = @"remindType";
static NSString *const c_initialStartTime = @"initialStartTime";
static NSString *const c_relateId         = @"relateId";
static NSString *const c_saveType         = @"saveType";

static NSString *const r_times  = @"times";
static NSString *const r_start  = @"start";
static NSString *const r_showId = @"showId";

@implementation CalendarEditResponse
@end

@implementation CalendarEditRequst

- (void)editScheduleByCalendarModel:(CalendarLaunchrModel *)model initialStartTime:(NSString *)initialStartTime WithSaveType:(NSInteger)SaveType{
    self.params[c_title] = model.try_title;
    [self timeHandle:model.try_time type:model.type wholeDay:model.try_wholeDay];
    
    CLLocationDegrees lng = model.try_place.coordinate.longitude;
    CLLocationDegrees lat = model.try_place.coordinate.latitude;

    self.params[c_lngx] = (lng != MAXLAT ?@(lng) : @"");
    self.params[c_laty] = (lat != MAXLAT ?@(lat) : @"");
    
    //needtorevise
    self.params[c_place]       = model.try_place.name;
//    self.params[c_place] = model.address;
    
    
    self.params[c_isImportant] = [NSNumber numberWithInt:model.try_important];
    self.params[c_showId]      = model.showId;
    self.params[c_content]     = model.try_content?:@"";
    self.params[c_isAllDay]    = [NSNumber numberWithInt:model.try_wholeDay];
    self.params[c_remindType]  = @(model.try_remindType);
    self.params[c_repeatType]  = @(model.try_repeatType);
    
    self.params[c_relateId] = model.relateId ?:@"";
    self.params[c_initialStartTime] = initialStartTime;
    self.params[c_saveType] = @(SaveType);
    
    if (!SaveType) {
        // saveType 为0时编辑此条为不重复
        self.params[c_repeatType] = @0;
    }
    
    [self requestData];
}

- (NSString *)api {
    return  @"/Schedule-Module/Schedule/Edit";
}

- (BaseResponse *)prepareResponse:(id)data {
    CalendarEditResponse *response = [CalendarEditResponse new];
    
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
    response.showIdNew = [data valueStringForKey:r_showId];
    
    return  response;
}

#pragma mark - Private Method

- (void)timeHandle:(NSArray *)times type:(NSString *)type wholeDay:(BOOL)wholeDay {
    NSMutableArray *startArray = [NSMutableArray array];
    NSMutableArray *endArray   = [NSMutableArray array];
    
    for (NSInteger  i = 0; i < [times count]; i += 2) {
        NSDate *startDate = times[i];
        NSDate *endDate = times[i + 1];
        
        if (wholeDay) {
            // 与服务器设置好的协议
            startDate = [NSDate dateWithYear:startDate.year month:startDate.month day:startDate.day];
            endDate   = [NSDate dateWithYear:endDate.year month:endDate.month day:endDate.day hour:23 minute:59 second:59];
        }
        
        long start = [startDate timeIntervalSince1970] * 1000;
        long end   = [endDate timeIntervalSince1970] * 1000;
        
        [startArray addObject:@(start)];
        [endArray addObject:@(end)];
    }
    
    self.params[c_start] = startArray ;
    self.params[c_end] = endArray;
    
    if ([type length]) {
        self.params[c_type] = type;
        return;
    }
    
    if ([startArray count] == 1) {
        self.params[c_type] = @"event";
    }else {
        self.params[c_type] = @"event_sure";
    }
}

@end