//
//  NewMeetingModel.m
//  launcher
//
//  Created by Lars Chen on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "NewMeetingModel.h"
#import "NSDictionary+SafeManager.h"
#import "MeetingJoinPersonModel.h"

#define MeetingDetail_SHOW_ID           @"SHOW_ID"
#define MeetingDetail_M_TITLE           @"M_TITLE"
#define MeetingDetail_M_CONTENT         @"M_CONTENT"
#define MeetingDetail_M_START           @"M_START"
#define MeetingDetail_M_END             @"M_END"
#define MeetingDetail_R_SHOW_ID         @"R_SHOW_ID"
#define MeetingDetail_M_EXTERNAL        @"M_EXTERNAL"
#define MeetingDetail_M_LNGX            @"M_LNGX"
#define MeetingDetail_M_LATY            @"M_LATY"
#define MeetingDetail_REQUIRE_JOIN      @"REQUIRE_JOIN"
#define MeetingDetail_JOIN              @"JOIN"
#define MeetingDetail_C_SHOW_ID         @"C_SHOW_ID"
#define MeetingDetail_R_SHOW_NAME       @"R_SHOW_NAME"
#define MeetingDetail_CREATE_USER       @"CREATE_USER"
#define MeetingDetail_CREATE_USER_NAME  @"CREATE_USER_NAME"
#define MeetingDetail_CREATE_TIME       @"CREATE_TIME"
#define MeetingDetail_M_RESTART_TYPE    @"M_RESTART_TYPE"
#define MeetingDetail_M_REMIND_TYPE     @"M_REMIND_TYPE"
#define MeetingDetail_REQUIRE_JOIN_NAME @"REQUIRE_JOIN_NAME"
#define MeetingDetail_JOIN_NAME         @"JOIN_NAME"
#define MeetingDetail_M_IS_VISIBLE         @"M_IS_VISIBLE"
#define MeetingDetail_M_IS_CANCEL       @"M_IS_CANCEL"
static NSString *const r_isVisible      = @"isVisible";
static NSString *const r_name 			 = @"NAME";
static NSString *const r_isCancel   	 = @"isCancel";

@interface NewMeetingModel ()

@property (nonatomic, strong) NSMutableDictionary *dictTry;

@end

@implementation NewMeetingModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if ([self init]) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            
            self.showID = [dict valueStringForKey:MeetingDetail_SHOW_ID];
            self.title = [dict valueStringForKey:MeetingDetail_M_TITLE];
            self.content = [dict valueStringForKey:MeetingDetail_M_CONTENT];
            self.rShowId = [dict valueStringForKey:MeetingDetail_R_SHOW_ID];
            self.place.name = [dict valueStringForKey:MeetingDetail_M_EXTERNAL];
           
            double lngx = [[dict valueNumberForKey:MeetingDetail_M_LNGX] doubleValue];
            double laty = [[dict valueNumberForKey:MeetingDetail_M_LATY] doubleValue];
            
            if (lngx || laty) {
                self.place.coordinate = CLLocationCoordinate2DMake(laty, lngx);
            } else {
                self.place.coordinate = CLLocationCoordinate2DMake(MAXLAT, MAXLAT);
            }
            
            NSMutableArray *arrRequireJoin = [NSMutableArray array];
            NSArray *arrayRequireJoin = [dict valueArrayForKey:MeetingDetail_REQUIRE_JOIN];
            NSArray *arrayRequireAccount = [dict valueArrayForKey:MeetingDetail_REQUIRE_JOIN_NAME];
            
            if (arrayRequireJoin.count > 0)
            {
                NSMutableArray *arrayTemp = [NSMutableArray array];
                NSMutableArray *arrayAccount = [NSMutableArray array];
                for (NSInteger i = 0; i < arrayRequireJoin.count; i ++) {
                    NSDictionary *dict = arrayRequireJoin[i];
                    NSDictionary *dictAccount = arrayRequireAccount[i];
            
                    MeetingJoinPersonModel *model = [[MeetingJoinPersonModel alloc] initWithDict:dict];
                    model.name = [dictAccount valueStringForKey:r_name];
                    
                    [arrayTemp addObject:model.name];
                    [arrayAccount addObject:model.NANE];
                    [arrRequireJoin addObject:model];
                }
                self.requireJoinName = [arrayTemp componentsJoinedByString:@"●"];
                self.requireJoin = [arrayAccount componentsJoinedByString:@"●"];
            }
            self.arrRequireJoin = [NSArray arrayWithArray:arrRequireJoin];
            
            NSMutableArray *arrJoin = [NSMutableArray array];
            NSArray *arrayJoin        = [dict valueArrayForKey:MeetingDetail_JOIN];
            NSArray *arrayJoinAccount = [dict valueArrayForKey:MeetingDetail_JOIN_NAME];
            
            if (arrayJoin.count > 0) {
                NSMutableArray *arrayTemp = [NSMutableArray array];
                NSMutableArray *arrayAccount = [NSMutableArray array];
                for (NSInteger i = 0; i < arrayJoin.count; i ++) {
                    NSDictionary *dict = arrayJoin[i];
                    NSDictionary *dictAccount = arrayJoinAccount[i];
                    
                    MeetingJoinPersonModel *model = [[MeetingJoinPersonModel alloc] initWithDict:dict];
                    model.name = [dictAccount valueStringForKey:r_name];
                    
                    [arrayTemp addObject:model.name];
                    [arrayAccount addObject:model.NANE];
                    [arrJoin addObject:model];
                }
    
                self.joinName = [arrayTemp componentsJoinedByString:@"●"];
                self.join = [arrayAccount componentsJoinedByString:@"●"];
            }
    
            self.arrJoin = [NSArray arrayWithArray:arrJoin];
            self.isVisible = [[dict valueNumberForKey:MeetingDetail_M_IS_VISIBLE] boolValue];
			self.isCancel = [[dict valueNumberForKey:MeetingDetail_M_IS_CANCEL] boolValue];
            self.showName = [dict valueStringForKey:MeetingDetail_R_SHOW_NAME];
            
            self.repeatType = [[dict valueNumberForKey:MeetingDetail_M_RESTART_TYPE] integerValue];
            self.remindType = [[dict valueNumberForKey:MeetingDetail_M_REMIND_TYPE] integerValue];
            
            long long startTime = [[dict valueNumberForKey:MeetingDetail_M_START] longLongValue];
            long long endTime = [[dict valueNumberForKey:MeetingDetail_M_END] longLongValue];
            self.startTime = [NSDate dateWithTimeIntervalSince1970:startTime / 1000];
            self.endTime = [NSDate dateWithTimeIntervalSince1970:endTime / 1000];
            
            self.createUser = [dict valueStringForKey:MeetingDetail_CREATE_USER];
			self.createUserName = [dict valueStringForKey:MeetingDetail_CREATE_USER_NAME];
        }
    }
    return self;
}

- (NSString *)repeatTypeString {
    NSArray *array = [CalendarLaunchrModel repeatArray];
    return [array objectAtIndex:self.try_repeatType];
}

- (NSString *)remindTypeString {
    NSArray *array = [CalendarLaunchrModel remindArrayWholeDay:NO];
    
    if (self.try_remindType == 0)
    {
        return [array objectAtIndex:0];
    }
    
    NSInteger index = self.try_remindType - 99;
    
    if (index > 50) {
        return [array lastObject];
    }
    
    return [array objectAtIndex:index];
}

- (void)initWithModel:(NewMeetingModel *)model
{
    self.remindType = model.remindType;
    self.place = model.place;
    self.rShowId = model.rShowId;
    self.showName = model.showName;
    self.requireJoin = model.requireJoin;
    self.requireJoinName = model.requireJoinName;
    self.join = model.join;
    self.joinName = model.joinName;
    self.repeatType = model.repeatType;
    self.title = model.title;
    self.content = model.content;
    self.startTime = model.startTime;
    self.endTime = model.endTime;
    self.showID = model.showID;
    self.arrJoin = model.arrJoin;
    self.arrRequireJoin = model.arrRequireJoin;
    self.createUser = model.createUser;
    self.isVisible = model.isVisible;
	self.isCancel = NO;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.remindType = calendar_remindTypeEventNo;
        self.place = [[PlaceModel alloc] initWithName:@""];
        self.rShowId = @"";
        self.showName = @"";
        self.requireJoin = @"";
        self.requireJoinName = @"";
        self.join = @"";
        self.joinName = @"";
        self.isVisible = NO;
		self.isCancel = NO;
    }
    return self;
}


// ************** 编辑新建 重写get、set **************//

- (void)removeAllAction {
    [self.dictTry removeAllObjects];
    self.dictTry = nil;
}

- (void)refreshAction {
    NSArray *arrayKeys = [self.dictTry allKeys];
    for (NSString *key in arrayKeys) {
        id value = [self.dictTry valueForKey:key];

        if ([key isEqualToString:MeetingDetail_M_TITLE]) {
            self.title = value;
        }
        else if ([key isEqualToString:MeetingDetail_M_CONTENT]) {
            self.content = value;
        }
        else if ([key isEqualToString:MeetingDetail_M_START]) {
            self.startTime = value;
        }
        else if ([key isEqualToString:MeetingDetail_M_END]) {
            self.endTime = value;
        }
        else if ([key isEqualToString:MeetingDetail_R_SHOW_ID]) {
            self.rShowId = value;
        }
        else if ([key isEqualToString:@"place"]) {
            self.place = value;
        }
        else if ([key isEqualToString:MeetingDetail_REQUIRE_JOIN]) {
            self.requireJoin = value;
        }
        else if ([key isEqualToString:MeetingDetail_REQUIRE_JOIN_NAME]) {
            self.requireJoinName = value;
        }
        else if ([key isEqualToString:MeetingDetail_JOIN]) {
            self.join = value;
        }
        else if ([key isEqualToString:MeetingDetail_JOIN_NAME]) {
            self.joinName = value;
        }
        else if ([key isEqualToString:MeetingDetail_M_REMIND_TYPE]) {
            self.remindType = [value integerValue];
        }
        else if ([key isEqualToString:MeetingDetail_M_RESTART_TYPE]) {
            self.repeatType = [value integerValue];
        }else if ([key isEqualToString:r_isVisible]){
            self.isVisible = value;
		}else if ([key isEqualToString:r_isCancel]) {
			self.isCancel = value;
		}
    }
}

- (NSString *)try_title {
    id value = [self.dictTry valueForKey:MeetingDetail_M_TITLE];
    return value ?: self.title;
}

- (void)setTry_title:(NSString *)try_title {
    [self.dictTry setObject:try_title forKey:MeetingDetail_M_TITLE];
}

- (NSString *)try_content {
    id value = [self.dictTry valueForKey:MeetingDetail_M_CONTENT];
    return value ?: self.content;
}

- (void)setTry_content:(NSString *)try_content {
    [self.dictTry setObject:try_content forKey:MeetingDetail_M_CONTENT];
}

- (NSDate *)try_startTime {
    id value = [self.dictTry objectForKey:MeetingDetail_M_START];
    return value ?: self.startTime;
}

- (void)setTry_startTime:(NSDate *)try_startTime {
    [self.dictTry setObject:try_startTime forKey:MeetingDetail_M_START];
}

- (NSDate *)try_endTime {
    id value = [self.dictTry valueForKey:MeetingDetail_M_END];
    return value ?: self.endTime;
}

- (void)setTry_endTime:(NSDate *)try_endTime {
    [self.dictTry setObject:try_endTime forKey:MeetingDetail_M_END];
}

- (NSString *)try_rShowId {
    id value = [self.dictTry valueForKey:MeetingDetail_R_SHOW_ID];
    return value ?: self.rShowId;
}

- (void)setTry_rShowId:(NSString *)try_rShowId {
    [self.dictTry setObject:try_rShowId forKey:MeetingDetail_R_SHOW_ID];
}

- (PlaceModel *)try_place {
    id value = [self.dictTry valueForKey:@"place"];
    return value ?: self.place;
}

- (void)setTry_place:(PlaceModel *)try_place {
    [self.dictTry setObject:try_place forKey:@"place"];
}

- (void)setplaceNil
{
    [self.dictTry removeObjectForKey:@"place"];
}

- (NSString *)try_requireJoin {
    id value = [self.dictTry valueForKey:MeetingDetail_REQUIRE_JOIN];
    return value ?: self.requireJoin;
}

- (void)setTry_requireJoin:(NSString *)try_requireJoin {
    [self.dictTry setObject:try_requireJoin forKey:MeetingDetail_REQUIRE_JOIN];
}

- (NSString *)try_requireJoinName {
    id value = [self.dictTry valueForKey:MeetingDetail_REQUIRE_JOIN_NAME];
    return value ?: self.requireJoinName;
}

- (void)setTry_requireJoinName:(NSString *)try_requireJoinName {
    [self.dictTry setObject:try_requireJoinName forKey:MeetingDetail_REQUIRE_JOIN_NAME];
}

- (NSString *)try_join {
    id value = [self.dictTry valueForKey:MeetingDetail_JOIN];
    return value ?: self.join;
}

- (void)setTry_join:(NSString *)try_join {
    [self.dictTry setObject:try_join forKey:MeetingDetail_JOIN];
}

- (NSString *)try_joinName {
    id value = [self.dictTry valueForKey:MeetingDetail_JOIN_NAME];
    return value ?: self.joinName;
}

- (void)setTry_joinName:(NSString *)try_joinName {
    [self.dictTry setObject:try_joinName forKey:MeetingDetail_JOIN_NAME];
}

- (calendar_repeatType)try_repeatType {
    id value = [self.dictTry valueForKey:MeetingDetail_M_RESTART_TYPE];
    if (value) {
        return [value integerValue];
    }
    
    return self.repeatType;
}

- (void)setTry_repeatType:(calendar_repeatType)try_repeatType {
    [self.dictTry setObject:@(try_repeatType) forKey:MeetingDetail_M_RESTART_TYPE];
}

- (calendar_remindType)try_remindType {
    id value = [self.dictTry valueForKey:MeetingDetail_M_REMIND_TYPE];
    if (value) {
        return [value integerValue];
    }
    
    return self.remindType;
}

- (void)setTry_isVisible:(BOOL)try_isVisible{
    [self.dictTry setObject:@(try_isVisible) forKey:r_isVisible];
}

- (void)setTry_isCancel:(BOOL)try_isCancel {
	[self.dictTry setObject:@(try_isCancel) forKey:r_isCancel];
}

- (void)setTry_remindType:(calendar_remindType)try_remindType {
    [self.dictTry setObject:@(try_remindType) forKey:MeetingDetail_M_REMIND_TYPE];
}

- (NSString *)try_showName {
    id value = [self.dictTry valueForKey:MeetingDetail_R_SHOW_NAME];
    return value ?: self.showName;
}

- (void)setTry_showName:(NSString *)try_showName {
    [self.dictTry setObject:try_showName forKey:MeetingDetail_R_SHOW_NAME];
}

- (BOOL)try_isVisible {
    id value = [self.dictTry valueForKey:r_isVisible];
    if (value) {
        return [value boolValue];
    }
    
    return self.isVisible;
}

- (BOOL)try_isCancel {
	id value = [self.dictTry valueForKey:r_isCancel];
	if (value) {
		return [value boolValue];
	}
	
	return self.isCancel;
}

// ************** 编辑新建 重写get、set **************//

- (NSMutableDictionary *)dictTry {
    if (!_dictTry) {
        _dictTry = [NSMutableDictionary dictionary];
    }
    return _dictTry;
}

@end
