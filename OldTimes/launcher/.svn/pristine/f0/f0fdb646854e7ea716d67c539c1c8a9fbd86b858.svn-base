//
//  MissionDetailModel.m
//  launcher
//
//  Created by William Zhang on 15/9/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MissionDetailModel.h"
#import "ContactPersonDetailInformationModel.h"
#import "NSDictionary+SafeManager.h"
#import "ProjectSearchDefine.h"
#import "ProjectModel.h"

//static NSString * const r_show_id          = @"SHOW_ID";
//static NSString * const r_p_show_id        = @"P_SHOW_ID";
//static NSString * const r_t_title          = @"T_TITLE";
//static NSString * const r_t_priority       = @"T_PRIORITY";
//static NSString * const r_t_users          = @"T_USERS";
//static NSString * const r_t_users_name     = @"T_USERS_NAME";
//static NSString * const r_t_end_time       = @"T_END_TIME";
//static NSString * const r_t_parent_show_id = @"T_PARENT_SHOW_ID";
//static NSString * const r_t_level          = @"T_LEVEL";
//static NSString * const r_t_is_annex       = @"T_IS_ANNEX";
//static NSString * const r_t_is_repeat      = @"T_IS_REPEAT";
//static NSString * const r_t_restart_type   = @"T_RESTART_TYPE";
//static NSString * const r_t_remind_time    = @"T_REMIND_TIME";
//static NSString * const r_t_backup         = @"T_BACKUP";
//static NSString * const r_s_show_id        = @"S_SHOW_ID";
//static NSString * const r_last_update_time = @"LAST_UPDATE_TIME";
//static NSString * const r_c_show_id        = @"C_SHOW_ID";
//static NSString * const r_create_user      = @"CREATE_USER";
//static NSString * const r_create_user_name = @"CREATE_USER_NAME";
//static NSString * const r_create_time      = @"CREATE_TIME";
//static NSString * const r_p_name           = @"P_NAME";
//static NSString * const r_allTask          = @"ALLTASK";
//static NSString * const r_finishTask       = @"FINISHTASK";
//static NSString * const r_taskChildList    = @"TaskChildList";
static NSString * const r_show_id          = @"showId";
static NSString * const r_p_show_id        = @"pShowId";
static NSString * const r_t_title          = @"tTitle";
static NSString * const r_t_priority       = @"tPriority";
static NSString * const r_t_users          = @"tUser";
static NSString * const r_t_users_name     = @"tUserName";
static NSString * const r_t_end_time       = @"tEndTime";
static NSString * const r_t_parent_show_id = @"tParentShowId";
static NSString * const r_t_level          = @"tLevel";

static NSString * const r_t_is_repeat      = @"tIsAnnex";
static NSString * const r_t_remind_time    = @"tRemindTime";
static NSString * const r_last_update_time = @"lastUpdateTime";
static NSString * const r_create_user      = @"createUser";
static NSString * const r_create_user_name = @"createUserName";
static NSString * const r_p_name           = @"pName";
static NSString * const r_taskChildList    = @"childTasks";


static NSString * const r_c_show_id        = @"C_SHOW_ID";
static NSString * const r_allTask          = @"ALLTASK";
static NSString * const r_finishTask       = @"FINISHTASK";
static NSString * const r_t_backup         = @"T_BACKUP";
static NSString * const r_s_show_id        = @"S_SHOW_ID";
static NSString * const r_t_restart_type   = @"T_RESTART_TYPE";
static NSString * const r_t_is_annex       = @"T_IS_ANNEX";
static NSString * const r_create_time      = @"CREATE_TIME";

@implementation MissionDetailModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super initWithDict:dict];
    if (self) {
        self.showId = [dict valueStringForKey:r_show_id];
        self.title = [dict valueStringForKey:r_t_title];
        
        NSString *priorityString = [dict valueStringForKey:r_t_priority];
        self.priority = [WhiteBoradStatusType getMissionPriority:priorityString];
        
        self.deadlineDate = [dict valueDateForKey:r_t_end_time];
        if ([self.deadlineDate isEqualToDate:[NSDate dateWithTimeIntervalSince1970:0]]) {
            self.deadlineDate = nil;
        }
        
        if ([self.deadlineDate compare:[NSDate dateWithTimeIntervalSince1970:0]] == NSOrderedAscending) {
            self.deadlineDate = nil;
        }
        
        self.parentTaskId = [dict valueStringForKey:r_t_parent_show_id];
        self.level = [[dict valueNumberForKey:r_t_level] integerValue];
        self.isAnnex = [dict valueBoolForKey:r_t_is_annex];
        
        BOOL repeat = [dict valueBoolForKey:r_t_is_repeat];
        if (!repeat) {
            [self setRepeatType:calendar_repeatNo];
        } else {
            self.repeatType = [[dict valueNumberForKey:r_t_restart_type] integerValue];
        }
        
        self.comment = [dict valueStringForKey:r_t_backup];
        
        self.createrUser     = [dict valueStringForKey:r_create_user];
        self.createrUserName = [dict valueStringForKey:r_create_user_name];
        
        self.projectId   = [dict valueStringForKey:r_p_show_id];
        self.projectName = [dict valueStringForKey:r_p_name];
        
        self.project = [[ProjectModel alloc] init];
        self.project.showId = self.projectId;
        self.project.name = self.projectName;
        
        self.allTask = [[dict valueNumberForKey:r_allTask] unsignedIntegerValue];
        self.finishedTask = [[dict valueNumberForKey:r_finishTask] unsignedIntegerValue];
        
        NSArray *arrayChild = [dict valueArrayForKey:r_taskChildList];
        self.subMissionArray = [NSMutableArray array];
        
        for (NSDictionary *dictChild in arrayChild) {
            if (!dictChild) {
                continue;
            }
            
            MissionDetailModel *childModel = [[MissionDetailModel alloc] initWithSubDict:dictChild];
            [self.subMissionArray addObject:childModel];
        }
        
        self.arrayUser     = [dict valueArrayForKey:r_t_users];
        self.arrayUserName = [dict valueArrayForKey:r_t_users_name];
        
        NSString *userShowId = [@[self.arrayUser] firstObject];
        ContactPersonDetailInformationModel *firstModel = [ContactPersonDetailInformationModel new];
        firstModel.show_id = userShowId;
        firstModel.u_true_name = [@[self.arrayUserName] firstObject];
        if (userShowId) {
            self.personArray = [NSMutableArray arrayWithObject:firstModel];
        }
    }
    return self;
}

- (NSMutableArray *)attachMentArray {
    if (!_attachMentArray) {
        _attachMentArray = [NSMutableArray array];
    }
    return _attachMentArray;
}

@end
