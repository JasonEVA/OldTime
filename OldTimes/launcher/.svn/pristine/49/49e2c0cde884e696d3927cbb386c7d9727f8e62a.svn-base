//
//  CalendarLaunchrModel.m
//  launcher
//
//  Created by William Zhang on 15/8/20.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarLaunchrModel.h"
#import "NSDictionary+SafeManager.h"
#import "DateTools.h"
#import "MyDefine.h"

static NSString *const  r_showId         = @"showId";
static NSString *const  r_title          = @"title";
static NSString *const  r_place          = @"place";
static NSString *const  r_lngx           = @"lngx";
static NSString *const  r_laty           = @"laty";
static NSString *const  r_isImportant    = @"isImportant";
static NSString *const  r_isAllDay       = @"isAllDay";
static NSString *const  r_isVisible      = @"isVisible";
static NSString *const  r_content        = @"content";
static NSString *const  r_repeatType     = @"repeatType";
static NSString *const  r_remindType     = @"remindType";
static NSString *const  r_times          = @"times";
static NSString *const  r_createUser     = @"createUser";
static NSString *const  r_createUserName = @"createUserName";

static NSString *const  r_start       = @"start";
static NSString *const  r_end         = @"end";
static NSString *const  r_type        = @"type";

static NSString *const  r_startTime   = @"startTime";
static NSString *const  r_endtime     = @"endTime";

static NSString *const  r_isCancel    = @"isCancel";
static NSString *const  r_relatedId   = @"relateId";

@interface CalendarLaunchrModel ()

@property (nonatomic, strong) NSMutableDictionary *dictTry;

@end

@implementation CalendarLaunchrModel

+ (NSArray *)repeatArray {
    return @[LOCAL(CALENDAR_NEVER_REPEAT), LOCAL(CALENDAR_REPEAT_EVERYDAY), LOCAL(CALENDAR_REPEAT_EVERYWEEK), LOCAL(CALENDAR_REPEAT_EVERYMONTH), LOCAL(CALENDAR_REPEAT_EVERYYEAR)];;
}

+ (NSArray *)remindArrayWholeDay:(BOOL)wholeDay {
    NSArray *array = @[
  @[LOCAL(CALENDAR_NEVER_REMIND),
    LOCAL(CALENDAR_BEFORE_EVENT_BEGIN),
    [NSString stringWithFormat:@"5%@",LOCAL(CALENDAR_MINUTES_BEFORE)],
    [NSString stringWithFormat:@"15%@",LOCAL(CALENDAR_MINUTES_BEFORE)],
    [NSString stringWithFormat:@"30%@",LOCAL(CALENDAR_MINUTES_BEFORE)],
    [NSString stringWithFormat:@"1%@",LOCAL(CALENDAR_HOURS_BEFORE)],
    [NSString stringWithFormat:@"2%@",LOCAL(CALENDAR_HOURS_BEFORE)],
    [NSString stringWithFormat:@"1%@",LOCAL(CALENADR_DAYS_BEFORE)],
    [NSString stringWithFormat:@"2%@",LOCAL(CALENADR_DAYS_BEFORE)],
    [NSString stringWithFormat:@"1%@",LOCAL(CALENDAR_WEEKS_BEFORE)]],

  @[LOCAL(CALENDAR_NEVER_REMIND),
    LOCAL(MEETING_EVENT_DAY),
    [NSString stringWithFormat:@"1%@",LOCAL(CALENADR_DAYS_BEFORE)],
    [NSString stringWithFormat:@"2%@",LOCAL(CALENADR_DAYS_BEFORE)],
    [NSString stringWithFormat:@"1%@",LOCAL(CALENDAR_WEEKS_BEFORE)]]];
    return [array objectAtIndex:(wholeDay ? 1 : 0)];
}

+ (NSArray *)remindNumbersIsWholeDay:(BOOL)wholeDay {
    NSArray *array = @[@[@0, @100, @101, @102, @103, @104, @105, @106, @107, @108],
             @[@0,@200, @201, @202, @203]];
    return [array objectAtIndex:(wholeDay ? 1 : 0)];
}

- (NSString *)repeatTypeString {
    NSArray *array = [CalendarLaunchrModel repeatArray];
    return [array objectAtIndex:self.try_repeatType];
}

+ (NSString *)repeatTypeStringAtIndex:(NSInteger)index {
    return [[self repeatArray] objectAtIndex:index];
}

- (NSString *)remindTypeString {
    NSArray *array = [CalendarLaunchrModel remindArrayWholeDay:self.try_wholeDay];
    
    if (self.try_remindType == calendar_remindTypeEventNo)
    {
        return [array firstObject];
    }
    
    // 前面还有一个不的东西，所以减（200 － 1）:(100 - 1)
    NSInteger index = self.try_remindType - (self.try_wholeDay ? 199 : 99);
    return [array objectAtIndex:index];
}

+ (NSString *)remindTypeStringAtIndex:(NSInteger)index {
    return [self remindTypeStringAtIndex:index wholeDay:NO];
}

+ (NSString *)remindTypeStringAtIndex:(NSInteger)index wholeDay:(BOOL)wholeDay {
    NSArray *array = [CalendarLaunchrModel remindArrayWholeDay:wholeDay];
    if (index == 0) {
        return [array firstObject];
    }
    
    NSInteger tempIndex = index - (wholeDay ? 199 : 99);
    return [array objectAtIndex:tempIndex];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.time = [NSMutableArray array];
        self.remindType = calendar_remindTypeEventStart;
    }
    return self;
}

- (instancetype)initWithDayDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.showId = [dict valueStringForKey:r_showId];
        
        NSString *placeName = [dict valueStringForKey:r_place];
        self.place = [[PlaceModel alloc] initWithName:placeName];
        
        NSString *lngString = [dict valueStringForKey:r_lngx];
        NSString *latString = [dict valueStringForKey:r_laty];
        
        double lng = (([lngString length] && ![lngString isEqualToString:@"0"]) ? [lngString doubleValue] : MAXLAT);
        double lat = (([latString length] && ![latString isEqualToString:@"0"]) ? [latString doubleValue] : MAXLAT);
        
        self.place.coordinate = CLLocationCoordinate2DMake(lat, lng);
        
        self.time = [NSMutableArray array];
        self.remindType = calendar_remindTypeEventStart;
        self.repeatType = [[dict valueNumberForKey:r_repeatType] integerValue];

        NSDate *startdate = [dict valueDateForKey:r_startTime];
        NSDate *enddate = [dict valueDateForKey:r_endtime];
        
        self.title = [dict valueStringForKey:r_title];
        self.type = [dict valueStringForKey:r_type];
        self.wholeDay = [[dict valueNumberForKey:r_isAllDay] boolValue];
        self.important = [[dict valueNumberForKey:r_isImportant] boolValue];
        self.Cancel   = [[dict valueNumberForKey:r_isCancel] boolValue];
        self.relateId = [dict valueStringForKey:r_relatedId];
        self.isVisible = [[dict valueNumberForKey:@"isVisible"] boolValue];
        [self.time addObject:startdate];
      
        //删除非全天事件显示在两天上
        if (enddate.hour == 0 && enddate.minute == 0 && !self.wholeDay)
        {
            enddate = [NSDate dateWithYear:enddate.year month:enddate.month day:enddate.day];
            enddate = [NSDate dateWithTimeInterval:-1 sinceDate:enddate];
        }
        
        if (self.wholeDay) {
            enddate = [NSDate dateWithYear:enddate.year month:enddate.month day:enddate.day];
            enddate = [NSDate dateWithTimeInterval:-1 sinceDate:enddate];
        }
        
        [self.time addObject:enddate];
        
        if ([self.type isEqualToString:@"meeting"]) {
            self.eventType = eventType_meeting_event;
        }
        else if ([self.type isEqualToString:@"event"] || [self.type isEqualToString:@"event_sure"])
        {
            self.eventType = eventType_calendar_event;
        }
        else if ([self.type isEqualToString:@"company_festival"])
        {
            self.eventType = eventType_company_festival;
        }
        else if ([self.type isEqualToString:@"statutory_festival"])
        {
            self.eventType = eventType_statutory_festival;
        }
        self.createUser = [dict valueStringForKey:r_createUser];
        self.createUserName = [dict valueStringForKey:r_createUserName];
        
    }
    return self;
}
- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [self init];
    if (self) {

        self.showId = [dict valueStringForKey:r_showId];
        self.title = [dict valueStringForKey:r_title];

        NSString *placeName = [dict valueStringForKey:r_place];
        self.place = [[PlaceModel alloc] initWithName:placeName];
        
        NSString *lngString = [dict valueStringForKey:r_lngx];
        NSString *latString = [dict valueStringForKey:r_laty];
        
        double lng = (([lngString length] && ![lngString isEqualToString:@"0"]) ? [lngString doubleValue] : MAXLAT);
        double lat = (([latString length] && ![latString isEqualToString:@"0"]) ? [latString doubleValue] : MAXLAT);
        
        self.place.coordinate = CLLocationCoordinate2DMake(lat, lng);
        
        self.important = [[dict valueForKey:r_isImportant] boolValue];
        self.isVisible = [[dict valueNumberForKey:@"isVisible"] boolValue];
        self.wholeDay = [[dict valueForKey:r_isAllDay] boolValue];
        self.content = [dict valueStringForKey:r_content];
        
        self.repeatType = [[dict valueNumberForKey:r_repeatType] integerValue];
		self.remindType = [[dict valueNumberForKey:r_remindType] integerValue];

        self.createUser = [dict valueStringForKey:r_createUser];
        self.createUserName = [dict valueStringForKey:r_createUserName];
        
        NSArray *timeArray = [dict valueArrayForKey:r_times];
        
        self.showIdList = [NSMutableArray array];
        for (NSDictionary *dictTime in timeArray) {
            if (dictTime) {
                NSDate *start = [dictTime valueDateForKey:r_start];
                NSDate *end   = [dictTime valueDateForKey:r_end];
                if (self.wholeDay) {
                    // 全天事件，服务器有可能返回的还是00:00
                    end = [NSDate dateWithYear:end.year month:end.month day:end.day hour:23 minute:55 second:00];
                }
                [self.time addObject:start];
                [self.time addObject:end];
                
                NSString *timeShowId = [dictTime valueStringForKey:r_showId];
                [self.showIdList addObject:timeShowId];
            }
        }
    }
    
    return self;
}

// ************** 编辑新建专用 get,set重写 **************//

- (void)removeTryAction {
    [self.dictTry removeAllObjects];
    self.dictTry = nil;
}

- (void)refreshAllAction {
    NSArray *arrayKeys = [self.dictTry allKeys];
    for (NSString *key in arrayKeys) {
        id value = [self.dictTry valueForKey:key];
        
        if ([key isEqualToString:r_title]) {
            self.title = value;
        }
        else if ([key isEqualToString:r_times]) {
            self.time = value;
        }
        else if ([key isEqualToString:r_place]) {
            self.place = value;
        }
        else if ([key isEqualToString:r_isImportant]) {
            self.important = [value boolValue];
        }
        else if ([key isEqualToString:r_isAllDay]) {
            self.wholeDay = [value boolValue];
        }
        else if ([key isEqualToString:r_content]) {
            self.content = value;
        }
        else if ([key isEqualToString:r_remindType]) {
            self.remindType = [value integerValue];
        }
        else if ([key isEqualToString:r_repeatType]) {
            self.repeatType = [value integerValue];
        }else if ([key isEqualToString:r_isVisible]){
            self.isVisible = [value boolValue];
        }
    }
    
    [self removeTryAction];
}

- (NSString *)try_title {
    id value = [self.dictTry valueForKey:r_title];
    return value ?: self.title;
}

- (void)setTry_title:(NSString *)try_title {
    [self.dictTry setObject:try_title forKey:r_title];
}

- (NSMutableArray *)try_time {
    id value = [self.dictTry valueForKey:r_times];
    return value ?: self.time;
}

- (void)setTry_time:(NSMutableArray *)try_time {
    [self.dictTry setObject:try_time forKey:r_times];
}

- (PlaceModel *)try_place {
    id value = [self.dictTry valueForKey:r_place];
    return value ?: self.place;
}

- (void)setTry_place:(PlaceModel *)try_place {
//    [self.dictTry setObject:try_place forKey:r_place];
    self.dictTry[r_place] = try_place;
}

- (BOOL)try_important {
    id value = [self.dictTry valueForKey:r_isImportant];
    if (value) {
        return [value boolValue];
    }
    
    return self.important;
}

- (void)setTry_important:(BOOL)try_important {
    [self.dictTry setObject:@(try_important) forKey:r_isImportant];
}

- (BOOL)try_wholeDay {
    id value = [self.dictTry valueForKey:r_isAllDay];
    if (value) {
        return [value boolValue];
    }
    
    return self.wholeDay;
}

- (BOOL)try_isVisible {
    id value = [self.dictTry valueForKey:r_isVisible];
    if (value) {
        return [value boolValue];
    }
    
    return self.isVisible;
}

- (void)setTry_wholeDay:(BOOL)try_wholeDay {
    [self.dictTry setObject:@(try_wholeDay) forKey:r_isAllDay];
}

- (void)setTry_isVisible:(BOOL)try_isVisible{
    [self.dictTry setObject:@(try_isVisible) forKey:r_isVisible];
}

- (NSString *)try_content {
    id value = [self.dictTry valueForKey:r_content];
    return value ?: self.content;
}

- (void)setTry_content:(NSString *)try_content {
    [self.dictTry setObject:try_content forKey:r_content];
}

-(calendar_repeatType)try_repeatType {
    id value = [self.dictTry valueForKey:r_repeatType];
    if (value) {
        return [value integerValue];
    }
    
    return self.repeatType;
}

- (void)setTry_repeatType:(calendar_repeatType)try_repeatType {
    [self.dictTry setObject:@(try_repeatType) forKey:r_repeatType];
}

- (calendar_remindType)try_remindType {
    id value = [self.dictTry valueForKey:r_remindType];
    if (value) {
        return [value integerValue];
    }
    
    return self.remindType;
}

- (void)setTry_remindType:(calendar_remindType)try_remindType {
    [self.dictTry setObject:@(try_remindType) forKey:r_remindType];
}

// ************** 编辑新建专用 get,set重写 **************//


- (NSMutableDictionary *)dictTry {
    if (!_dictTry) {
        _dictTry = [NSMutableDictionary dictionary];
    }
    return _dictTry;
}

@end
