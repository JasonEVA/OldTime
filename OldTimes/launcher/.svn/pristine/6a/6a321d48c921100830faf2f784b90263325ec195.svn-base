//
//  TaskEditRequest.m
//  launcher
//
//  Created by William Zhang on 15/9/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "TaskEditRequest.h"
#import "ContactPersonDetailInformationModel.h"
#import "ProjectSearchDefine.h"
#import "ApplicationAttachmentModel.h"
#import "UnifiedUserInfoManager.h"
#import "TaskCreateAndEditDefine.h"
#import "MissionDetailModel.h"

@interface NSDictionary (Util)

- (id)getComponents:(TaskCreateAndEditRequestType)taskType;

@end

@implementation NSDictionary (Util)

- (id)getComponents:(TaskCreateAndEditRequestType)taskType {
    return [self objectForKey:@(taskType)];
}

@end

static const NSString * d_title          = @"TITLE";
static const NSString * d_showId         = @"SHOW_ID";
static const NSString * d_p_showId       = @"P_SHOW_ID";
static const NSString * d_t_parentShowId = @"T_PARENT_SHOW_ID";
static const NSString * d_t_priority     = @"T_PRIORITY";
static const NSString * d_t_users        = @"T_USERS";
static const NSString * d_t_usersName    = @"T_USERS_NAME";
static const NSString * d_t_endTime      = @"T_END_TIME";
static const NSString * d_t_isAnnex      = @"T_IS_ANNEX";
static const NSString * d_t_backUp       = @"T_BACKUP";
static const NSString * d_fileShowId     = @"fileShowIds";
static const NSString * d_remindtype     = @"T_REMIND_TYPE";

@implementation TaskEditRequest

- (void)editTaskModel:(MissionDetailModel *)detailModel editDitionary:(NSDictionary *)editDict {
    self.params[d_title] = [editDict getComponents:kTaskCreateAndEditRequestTypeTitle] ?: detailModel.title;
    self.params[d_showId] = detailModel.showId;
    self.params[d_p_showId] = detailModel.projectId;
    
    self.params[d_remindtype] = @((NSInteger)detailModel.remindType);
    
    NSNumber *priorityNumber = [editDict getComponents:kTaskCreateAndEditRequestTypePriority] ?: @(detailModel.priority);
    self.params[d_t_priority] = [WhiteBoradStatusType getMissionPriorityString:[priorityNumber integerValue]];
    
    [self userNameComponents:[editDict getComponents:kTaskCreateAndEditRequestTypePeople] ?: detailModel.personArray];
    
    NSDate *endDate = [editDict getComponents:kTaskCreateAndEditRequestTypeDeadline] ?: detailModel.deadlineDate;
    if (endDate) {
        long long timeInterval = [endDate timeIntervalSince1970] * 1000;
        self.params[d_t_endTime] = [NSNumber numberWithLongLong:timeInterval];
    }

    self.params[d_t_backUp] = [editDict getComponents:kTaskCreateAndEditRequestTypeComment] ?: detailModel.comment;
    
    NSArray *attachmentArray = [editDict getComponents:kTaskCreateAndEditRequestTypeAttach] ?: detailModel.attachMentArray;
    NSMutableArray *attachShowId = [NSMutableArray array];
    for (ApplicationAttachmentModel *attachment in attachmentArray) {
        [attachShowId addObject:attachment.showId];
    }
    
    self.params[d_fileShowId] = attachShowId;
    self.params[d_t_isAnnex] = [attachShowId count] ? @1 : @0;

    self.params[d_t_parentShowId] = detailModel.parentTaskId;
    
    [self requestData];
}

- (NSString *)api { return @"/Task-Module/Task/UpdateTask";}

- (void)userNameComponents:(NSArray *)array {
    if (!array || ![array count]) {
        self.params[d_t_usersName] = [[UnifiedUserInfoManager share] userName];
        self.params[d_t_users] = [[UnifiedUserInfoManager share] userShowID];
        return;
    }
    
    NSMutableArray *arrayUser     = [NSMutableArray array];
    NSMutableArray *arrayUserName = [NSMutableArray array];
    
    for (ContactPersonDetailInformationModel *person in array) {
        [arrayUser addObject:person.show_id];
        [arrayUserName addObject:person.u_true_name];
    }
    
    self.params[d_t_users]     = [arrayUser componentsJoinedByString:@"●"];
    self.params[d_t_usersName] = [arrayUserName componentsJoinedByString:@"●"];
}

@end
