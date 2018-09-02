//
//  MeetingNewRequest.m
//  launcher
//
//  Created by Lars Chen on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingNewRequest.h"
#import "NSDictionary+SafeManager.h"
#import "UnifiedUserInfoManager.h"

static NSString *const  d_M_TITLE           = @"M_TITLE";
static NSString *const  d_M_CONTENT         = @"M_CONTENT";
static NSString *const  d_M_START           = @"M_START";
static NSString *const  d_M_END             = @"M_END";
static NSString *const  d_R_SHOW_ID         = @"R_SHOW_ID";
static NSString *const  d_M_EXTERNAL        = @"M_EXTERNAL";
static NSString *const  d_M_LNGX            = @"M_LNGX";
static NSString *const  d_M_LATY            = @"M_LATY";
static NSString *const  d_M_REQUIRE_JOIN    = @"M_REQUIRE_JOIN";
static NSString *const  d_M_REQUIRE_JOIN_NAME       = @"M_REQUIRE_JOIN_NAME";
static NSString *const  d_M_JOIN                    = @"M_JOIN";
static NSString *const  d_M_JOIN_NAME               = @"M_JOIN_NAME";
static NSString *const  d_M_RESTART_TYPE            = @"M_RESTART_TYPE";
static NSString *const  d_M_REMIND_TYPE             = @"M_REMIND_TYPE";
static NSString *const  d_R_SHOW_NAME               = @"R_SHOW_NAME";
static NSString *const  d_SHOW_ID                   = @"SHOW_ID";
static NSString *const  d_isVisible          = @"M_IS_VISIBLE";

@implementation MeetingNewResponse

@end

@interface MeetingNewRequest ()

@property (nonatomic, strong) NewMeetingModel *meetingModel;

@end

@implementation MeetingNewRequest

- (NSString *)api  { return @"/Schedule-Module/Meeting";}
- (NSString *)type { return @"PUT";}

- (void)newMeetingModel:(NewMeetingModel *)model
{
    self.meetingModel = model;
    
    CLLocationDegrees lng = model.try_place.coordinate.longitude;
    CLLocationDegrees lat = model.try_place.coordinate.latitude;
    
    self.params[d_M_TITLE] = model.try_title;
    self.params[d_M_CONTENT] = model.try_content?:@"";
    self.params[d_M_START] = [NSNumber numberWithLongLong:[model.try_startTime timeIntervalSince1970] * 1000];
    self.params[d_M_END] = [NSNumber numberWithLongLong:[model.try_endTime timeIntervalSince1970] * 1000];
    self.params[d_R_SHOW_ID] = model.try_rShowId ?:@"";
    self.params[d_M_EXTERNAL] = model.try_place.name;
    self.params[d_M_LNGX] = (lng != MAXLAT ? @(lng) : @"");
    self.params[d_M_LATY] = (lat != MAXLAT ? @(lat) : @"");
    self.params[d_isVisible] = [NSNumber numberWithInt:model.try_isVisible];
    self.params[d_M_REQUIRE_JOIN] = model.try_requireJoin;
    self.params[d_M_REQUIRE_JOIN_NAME] = model.try_requireJoinName;
    self.params[d_M_JOIN] = model.try_join ?:@"";
    self.params[d_M_JOIN_NAME] = model.try_joinName ?:@"";
    self.params[d_M_RESTART_TYPE] = @(model.try_repeatType);
    self.params[d_M_REMIND_TYPE] = @(model.try_remindType);
    
    [self requestData];
}

- (BaseResponse *)prepareResponse:(id)data
{
    MeetingNewResponse *response = [MeetingNewResponse new];
    
    response.meetingModel = self.meetingModel;
    response.meetingModel.showName = [data valueStringForKey:d_R_SHOW_NAME];
    response.meetingModel.showID = [data valueStringForKey:d_SHOW_ID];
    
    return response;
}

@end
