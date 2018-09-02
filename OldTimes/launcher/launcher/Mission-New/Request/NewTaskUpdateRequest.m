//
//  NewTaskUpdateRequest.m
//  launcher
//
//  Created by TabLiu on 16/2/21.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewTaskUpdateRequest.h"
#import "ContactPersonDetailInformationModel.h"
#import "ProjectSearchDefine.h"
#import "ApplicationAttachmentModel.h"
#import "UnifiedUserInfoManager.h"
#import "TaskCreateAndEditDefine.h"
#import "ProjectContentModel.h"

static NSString * const d_title           = @"tTitle";
static NSString * const d_showId           = @"showId";
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

@interface NSDictionary (Util)

- (id)getComponents:(TaskCreateAndEditRequestType)taskType;

@end

@implementation NSDictionary (Util)

- (id)getComponents:(TaskCreateAndEditRequestType)taskType {
    return [self objectForKey:@(taskType)];
}

@end
@implementation NewTaskUpdateRequest

- (NSString *)api { return @"/Task-Module/TaskV2/TaskUpdate";}
- (NSString *)type { return @"POST";}
- (BaseResponse *)prepareResponse:(id)data {
    NewTaskUpdateResponse *response = [NewTaskUpdateResponse new];
    return response;
}

//- (void)requestWithShowID:(NSString *)ShowID status:(NSString *)status
//{
//    [self setValue:_showId forKey:@"showId"];
//    [self setValue:_pShowId forKey:@"pShowId"];
//    [self setValue:_tTitle forKey:@"tTitle"];
//    [self setValue:_tContent forKey:@"tContent"];
//    [self setValue:@(_tStartTime) forKey:@"tStartTime"];
//    [self setValue:@(_tEndTime) forKey:@"tEndTime"];
//    [self setValue:@(_isStartTimeAllDay) forKey:@"isStartTimeAllDay"];
//    [self setValue:@(_isEndTimeAllDay) forKey:@"isEndTimeAllDay"];
//    [self setValue:_tUser forKey:@"tUser"];
//    [self setValue:_tUserName forKey:@"tUserName"];
//    [self setValue:_tPriority forKey:@"tPriority"];
//    [self setValue:@(_tRemindType) forKey:@"tRemindType"];
//    [self setValue:_fileShowIds forKey:@"fileShowIds"];
//
//    [super requestData];
//}
- (void)editTaskModel:(NewMissionDetailModel *)detailModel editDitionary:(NSDictionary *)editDict {
    self.params[d_title] = [editDict getComponents:kTaskCreateAndEditRequestTypeTitle] ?: detailModel.title;
    self.params[d_showId] = detailModel.showId;
    if ([editDict getComponents:kTaskCreateAndEditRequestTypeProject]) {
        ProjectContentModel *model = [[ProjectContentModel alloc] init];
        model = [editDict getComponents:kTaskCreateAndEditRequestTypeProject];
        self.params[d_p_show_id] = model.showId;
    } else {
        self.params[d_p_show_id] = detailModel.projectId;

    }
    
    self.params[d_t_remindtype] = [editDict objectForKey:@(kTaskCreateAndEditRequestTypeRemind)];

    NSNumber *priorityNumber = [editDict getComponents:kTaskCreateAndEditRequestTypePriority] ?: @(detailModel.priority);
    self.params[d_t_prioriry] = [WhiteBoradStatusType getMissionPriorityString:[priorityNumber integerValue]];

    if ([editDict getComponents:kTaskCreateAndEditRequestTypePeople]) {
        ContactPersonDetailInformationModel *model = [[ContactPersonDetailInformationModel alloc]init];
        NSArray *arr = [editDict getComponents:kTaskCreateAndEditRequestTypePeople];
        model = arr.firstObject;
        self.params[d_t_users] = model.show_id;
        self.params[d_t_users_name] = model.u_true_name;
    } else {
        self.params[d_t_users] = detailModel.userName;
        self.params[d_t_users_name] = detailModel.userTrueName;
    }
    if ([editDict objectForKey:@(kTaskCreateAndEditRequestTypeStartTime)]) {
        if ([[editDict objectForKey:@(kTaskCreateAndEditRequestTypeStartTime)] isKindOfClass:[NSDate class]]) {
            NSDate *startTime = [editDict objectForKey:@(kTaskCreateAndEditRequestTypeStartTime)];
            long long startTimeInterval = [startTime timeIntervalSince1970] * 1000;
            
            self.params[d_t_start_time] = [NSNumber numberWithLongLong:startTimeInterval];
        }
    } else {
        self.params[d_t_start_time] = [NSNumber numberWithLongLong:detailModel.startTime];
    }
    
    if ([self.params[d_t_start_time] longLongValue] == 0) {
        self.params[d_t_start_time] = nil;
    }
    
    if ([editDict objectForKey:@(kTaskCreateAndEditRequestTypeDeadline)]) {
        if ([[editDict objectForKey:@(kTaskCreateAndEditRequestTypeDeadline)] isKindOfClass:[NSDate class]]) {
            NSDate *endtime = [editDict objectForKey:@(kTaskCreateAndEditRequestTypeDeadline)];
            long long endTimeInterval = [endtime timeIntervalSince1970] * 1000;
            self.params[d_t_end_time] = [NSNumber numberWithLongLong:endTimeInterval];
        }
    } else {
        self.params[d_t_end_time] = [NSNumber numberWithLongLong:detailModel.endTime];
    }
    
    if ([self.params[d_t_end_time] longLongValue] == 0) {
        self.params[d_t_end_time] = nil;
    }

//    if ([[editDict objectForKey:@(kTaskCreateAndEditRequestTypeDeadline)] isKindOfClass:[NSDate class]]) {
//        NSDate *deadLine = [NSDate date];
//        if ([editDict objectForKey:@(kTaskCreateAndEditRequestTypeDeadline)]) {
//            deadLine = [editDict objectForKey:@(kTaskCreateAndEditRequestTypeDeadline)];
//            long long timeInterval = [deadLine timeIntervalSince1970] * 1000;
//            self.params[d_t_end_time] = [NSNumber numberWithLongLong:timeInterval];
//
//        } else {
//            self.params[d_t_end_time] = [NSNumber numberWithLongLong:detailModel.endTime];
//        }
//    }
//
    self.params[d_tContent] = [editDict getComponents:kTaskCreateAndEditRequestTypeComment] ?: detailModel.content;
    
    NSArray *attachmentArray = [editDict getComponents:kTaskCreateAndEditRequestTypeAttach] ?: detailModel.attachMentArray;
    NSMutableArray *attachShowId = [NSMutableArray array];
    for (ApplicationAttachmentModel *attachment in attachmentArray) {
        [attachShowId addObject:attachment.showId];
    }
    
    self.params[d_fileShowIds] = attachShowId;
    self.params[d_t_isannex] = [attachShowId count] ? @1 : @0;
    
    self.params[d_t_parent_showId] = detailModel.parentTaskId;
    
    if ([editDict objectForKey:@(kTaskCreateAndEditRequestTypeIsStartTimeAllDay)]) {
        if ([[editDict objectForKey:@(kTaskCreateAndEditRequestTypeIsStartTimeAllDay)] integerValue]) {
            self.params[d_is_start_allDay] = @1;
        } else {
            self.params[d_is_start_allDay] = @0;
        }
    } else {
        self.params[d_is_start_allDay] = @(detailModel.isStartTimeAllDay);
    }
    
    if ([editDict objectForKey:@(kTaskCreateAndEditRequestTypeIsEndTimeAllDay)]) {
        if ([[editDict objectForKey:@(kTaskCreateAndEditRequestTypeIsEndTimeAllDay)] integerValue]) {
            self.params[d_is_end_allDay] = @1;
        } else {
            self.params[d_is_end_allDay] = @0;
        }
    } else {
        self.params[d_is_end_allDay] = @(detailModel.isEndTimeAllDay);
    }
    
    [self requestData];
}
@end

@implementation NewTaskUpdateResponse

@end