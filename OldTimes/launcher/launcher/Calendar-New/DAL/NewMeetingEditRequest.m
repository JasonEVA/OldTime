//
//  NewMeetingEditRequest.m
//  launcher
//
//  Created by 马晓波 on 16/4/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMeetingEditRequest.h"
#import "NewMeetingModel.h"
#import "NSDictionary+SafeManager.h"
#import "UnifiedUserInfoManager.h"
static NSString *const  d_showId            = @"SHOW_ID";
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


@interface NewMeetingEditRequest()
@property (nonatomic, strong) NewMeetingModel *meetingModel;
@end

@implementation NewMeetingEditRequest


- (void)newMeetingModel:(NewMeetingModel *)model
{
    self.meetingModel = model;
    
    CLLocationDegrees lng = model.try_place.coordinate.longitude;
    CLLocationDegrees lat = model.try_place.coordinate.latitude;
    self.params[d_showId] = model.showID;
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
//    if ([model.try_requireJoin rangeOfString:[[UnifiedUserInfoManager share] userShowID]].location == NSNotFound) {
//        // 已经有本人了，不重复添加
//        self.params[d_M_REQUIRE_JOIN] = [model.try_requireJoin stringByAppendingFormat:@"●%@",[[UnifiedUserInfoManager share] userShowID]];
//        self.params[d_M_REQUIRE_JOIN_NAME] = [model.try_requireJoinName stringByAppendingFormat:@"●%@",[[UnifiedUserInfoManager share] userName]];
//    }
	
    self.params[d_M_JOIN] = model.try_join ?:@"";
    self.params[d_M_JOIN_NAME] = model.try_joinName ?:@"";
    self.params[d_M_RESTART_TYPE] = @(model.try_repeatType);
    self.params[d_M_REMIND_TYPE] = @(model.try_remindType);
    
    [self requestData];
}


- (NSString *)api
{
    return @"/Schedule-Module/Meeting/PostMeeting";
}

- (NSString *)type
{
    return @"POST";
}

- (BaseResponse *)prepareResponse:(id)data
{
    NewMeetingEditResponse *response = [NewMeetingEditResponse new];
    response.meetingModel = self.meetingModel;
    return response;
}
@end

@interface NewMeetingEditResponse()

@end

@implementation NewMeetingEditResponse

@end