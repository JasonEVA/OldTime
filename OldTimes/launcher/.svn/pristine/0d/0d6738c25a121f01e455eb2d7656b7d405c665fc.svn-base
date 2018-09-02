//
//  NewTaskCreateRequest.m
//  launcher
//
//  Created by jasonwang on 16/2/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewTaskCreateRequest.h"
#import "ContactPersonDetailInformationModel.h"
#import "applicationAttachmentModel.h"
#import "NSDictionary+SafeManager.h"
#import "UnifiedUserInfoManager.h"
#import "ProjectSearchDefine.h"
#import "ProjectModel.h"

static NSString * const d_title           = @"tTitle";
static NSString * const d_tContent           = @"tContent";
static NSString * const d_p_show_id       = @"pShowId";
static NSString * const d_t_prioriry      = @"tPriority";
static NSString * const d_t_users         = @"tUser";
static NSString * const d_t_users_name    = @"tUserName";
static NSString * const d_t_start_time      = @"tStartTime";
static NSString * const d_t_end_time      = @"tEndTime";
static NSString * const d_t_isannex       = @"T_IS_ANNEX";
static NSString * const d_t_parent_showId = @"tParentShowId";
static NSString * const d_t_backup        = @"T_BACKUP";
static NSString * const d_fileShowIds     = @"fileShowIds";
static NSString * const d_t_remindtype    = @"tRemindType";
static NSString * const d_is_start_allDay    = @"isStartTimeAllDay";
static NSString * const d_is_end_allDay    = @"isEndTimeAllDay";

static NSString * const r_p_showId = @"pShowId";
static NSString * const showId = @"SHOW_ID";

@implementation NewTaskCreateResponse
@end

@implementation NewTaskCreateRequest

- (void)createTask:(NSDictionary *)dict parentId:(NSString *)parentId {
    self.params[d_title] = [dict objectForKey:@(kTaskCreateAndEditRequestTypeTitle)];
    self.params[d_tContent] = [dict objectForKey:@(kTaskCreateAndEditRequestTypeComment)];
    ProjectModel *project    = [dict objectForKey:@(kTaskCreateAndEditRequestTypeProject)];
    self.params[d_p_show_id] = project.showId;
    
    NSNumber *priorityNumber  = [dict objectForKey:@(kTaskCreateAndEditRequestTypePriority)];
    self.params[d_t_prioriry] = [WhiteBoradStatusType getMissionPriorityString:[priorityNumber integerValue]];
    
    NSArray *arrayPeople = [dict objectForKey:@(kTaskCreateAndEditRequestTypePeople)];
    [self userNameComponents:arrayPeople];
    if ([[dict objectForKey:@(kTaskCreateAndEditRequestTypeStartTime)] isKindOfClass:[NSDate class]]) {
        NSDate *startTime = [NSDate date];
        if ([dict objectForKey:@(kTaskCreateAndEditRequestTypeStartTime)]) {
            startTime = [dict objectForKey:@(kTaskCreateAndEditRequestTypeStartTime)];
        }
        
        long long startTimeInterval = [startTime timeIntervalSince1970] * 1000;
        self.params[d_t_start_time] = [NSNumber numberWithLongLong:startTimeInterval];
    }
    
    if ([[dict objectForKey:@(kTaskCreateAndEditRequestTypeDeadline)] isKindOfClass:[NSDate class]]) {
        NSDate *deadLine = [NSDate date];
        if ([dict objectForKey:@(kTaskCreateAndEditRequestTypeDeadline)]) {
            deadLine = [dict objectForKey:@(kTaskCreateAndEditRequestTypeDeadline)];
        }
        
        long long timeInterval = [deadLine timeIntervalSince1970] * 1000;
        self.params[d_t_end_time] = [NSNumber numberWithLongLong:timeInterval];
    }
    self.params[d_t_parent_showId] = parentId ?:@"";
    
//    if ([dict objectForKey:@(kTaskCreateAndEditRequestTypeComment)]) {
//        self.params[d_t_backup] = [dict objectForKey:@(kTaskCreateAndEditRequestTypeComment)];
//    }
    
    NSArray *attachmentArray = [dict objectForKey:@(kTaskCreateAndEditRequestTypeAttach)];
    NSMutableArray *attachShowId = [NSMutableArray array];
    for (ApplicationAttachmentModel *attachment in attachmentArray) {
        [attachShowId addObject:attachment.showId];
    }

    self.params[d_is_start_allDay] = [[dict objectForKey:@(kTaskCreateAndEditRequestTypeIsStartTimeAllDay)] boolValue] ? @1 : @0;
    self.params[d_is_end_allDay] = [[dict objectForKey:@(kTaskCreateAndEditRequestTypeIsEndTimeAllDay)] boolValue] ? @1 : @0;

    self.params[d_fileShowIds] = attachShowId;
    self.params[d_t_isannex]   = [attachShowId count] ? @1 : @0;
    self.params[d_t_remindtype] = [dict objectForKey:@(kTaskCreateAndEditRequestTypeRemind)];
    
    [self requestData];
}

- (NSString *)api { return @"/Task-Module/TaskV2/TaskAdd";}
- (NSString *)type { return @"PUT";}

- (void)userNameComponents:(NSArray *)array {
    if (!array || ![array count]) {
        return;
    }
    
    NSMutableArray *arrayUser     = [NSMutableArray array];
    NSMutableArray *arrayUserName = [NSMutableArray array];
    
    for (ContactPersonDetailInformationModel *person in array) {
        [arrayUser addObject:person.show_id];
        [arrayUserName addObject:person.u_true_name];
    }
    
    self.params[d_t_users]      = [arrayUser componentsJoinedByString:@"●"];
    self.params[d_t_users_name] = [arrayUserName componentsJoinedByString:@"●"];
}

- (BaseResponse *)prepareResponse:(id)data {
   NewTaskCreateResponse *response = [NewTaskCreateResponse new];
    
    response.projectId = [data valueStringForKey:r_p_showId];
    response.showId = [data valueStringForKey:@"showId"];
    
    return response;
}

@end
