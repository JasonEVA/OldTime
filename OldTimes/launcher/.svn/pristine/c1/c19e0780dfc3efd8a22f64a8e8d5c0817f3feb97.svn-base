//
//  TaskCreateRequest.m
//  launcher
//
//  Created by William Zhang on 15/9/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "TaskCreateRequest.h"
#import "ContactPersonDetailInformationModel.h"
#import "applicationAttachmentModel.h"
#import "NSDictionary+SafeManager.h"
#import "UnifiedUserInfoManager.h"
#import "ProjectSearchDefine.h"
#import "ProjectModel.h"

static NSString * const d_title           = @"TITLE";
static NSString * const d_p_show_id       = @"P_SHOW_ID";
static NSString * const d_t_prioriry      = @"T_PRIORITY";
static NSString * const d_t_users         = @"T_USERS";
static NSString * const d_t_users_name    = @"T_USERS_NAME";
static NSString * const d_t_end_time      = @"T_END_TIME";
static NSString * const d_t_isannex       = @"T_IS_ANNEX";
static NSString * const d_t_parent_showId = @"T_PARENT_SHOW_ID";
static NSString * const d_t_backup        = @"T_BACKUP";
static NSString * const d_fileShowIds     = @"fileShowIds";
static NSString * const d_t_remindtype    = @"T_REMIND_TYPE";

static NSString * const r_p_showId = @"P_SHOW_ID";

static NSString * const showId = @"SHOW_ID";

@implementation TaskCreateResponse
@end

@implementation TaskCreateRequest

- (void)createTask:(NSDictionary *)dict parentId:(NSString *)parentId {
    self.params[d_title] = [dict objectForKey:@(kTaskCreateAndEditRequestTypeTitle)];
    
    ProjectModel *project    = [dict objectForKey:@(kTaskCreateAndEditRequestTypeProject)];
    self.params[d_p_show_id] = project.showId;
    
    NSNumber *priorityNumber  = [dict objectForKey:@(kTaskCreateAndEditRequestTypePriority)];
    self.params[d_t_prioriry] = [WhiteBoradStatusType getMissionPriorityString:[priorityNumber integerValue]];
    
    NSArray *arrayPeople = [dict objectForKey:@(kTaskCreateAndEditRequestTypePeople)];
    [self userNameComponents:arrayPeople];
    
    NSDate *deadLine = [NSDate date];
    if ([dict objectForKey:@(kTaskCreateAndEditRequestTypeDeadline)]) {
        deadLine = [dict objectForKey:@(kTaskCreateAndEditRequestTypeDeadline)];
    }
    
    long long timeInterval = [deadLine timeIntervalSince1970] * 1000;
    self.params[d_t_end_time] = [NSNumber numberWithLongLong:timeInterval];

    self.params[d_t_parent_showId] = parentId ?:@"";
    
    if ([dict objectForKey:@(kTaskCreateAndEditRequestTypeComment)]) {
        self.params[d_t_backup] = [dict objectForKey:@(kTaskCreateAndEditRequestTypeComment)];
    }
    
    NSArray *attachmentArray = [dict objectForKey:@(kTaskCreateAndEditRequestTypeAttach)];
    NSMutableArray *attachShowId = [NSMutableArray array];
    for (ApplicationAttachmentModel *attachment in attachmentArray) {
        [attachShowId addObject:attachment.showId];
    }
    
    self.params[d_fileShowIds] = attachShowId;
    self.params[d_t_isannex]   = [attachShowId count] ? @1 : @0;
    self.params[d_t_remindtype] = [dict objectForKey:@(kTaskCreateAndEditRequestTypeRemind)];
    
    [self requestData];
}

- (NSString *)api { return @"/Task-Module/Task/AddTask";}
- (NSString *)type { return @"PUT";}

- (void)userNameComponents:(NSArray *)array {
    if (!array || ![array count]) {
        self.params[d_t_users_name] = [[UnifiedUserInfoManager share] userName];
        self.params[d_t_users] = [[UnifiedUserInfoManager share] userShowID];
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
    TaskCreateResponse *response = [TaskCreateResponse new];
    
    response.projectId = [data valueStringForKey:r_p_showId];
    response.showId = [data valueStringForKey:showId];
    
    return response;
}

@end
