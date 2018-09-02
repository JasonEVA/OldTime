//
//  MissionMainViewModel.m
//  launcher
//
//  Created by Kyle He on 15/9/1.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MissionMainViewModel.h"
#import "NSDictionary+SafeManager.h"

static NSString * const r_projectId     = @"projectId";
static NSString * const r_projectName   = @"projectName";
static NSString * const r_statusId      = @"statusId";
static NSString * const r_statustype    = @"statustype";
static NSString * const r_statusName    = @"statusName";
static NSString * const r_taskId        = @"taskId";
static NSString * const r_title         = @"title";
static NSString * const r_priority      = @"priority";
static NSString * const r_level         = @"level";
static NSString * const r_parentTaskId  = @"parentTaskId";
static NSString * const r_image         = @"image";
static NSString * const r_endTime       = @"endTime";
static NSString * const r_isAnnex       = @"isAnnex";
static NSString * const r_finishedTask  = @"finishedTask";
static NSString * const r_allTask       = @"allTask";
static NSString * const r_userNames     = @"userNames";
static NSString * const r_userTrueNames = @"userTrueNames";

//////  任务详情中子任务初始化     //////////
static NSString * const r_imgLog    = @"imgLog";
static NSString * const r_status    = @"status";
static NSString * const r_proiority = @"proiority";// 服务端拼写错误，不是我拼错的！
static NSString * const r_t_isAnnex = @"T_IS_ANNEX";
static NSString * const r_showId    = @"showId";
static NSString * const r_stype     = @"sType";

//////  任务详情中子任务初始化     //////////
@implementation MissionMainViewModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.projectId = [dict valueStringForKey:r_projectId];
        self.projectName = [dict valueStringForKey:r_projectName];
        
        self.statusId = [dict valueStringForKey:r_statusId];
        NSString *statusTypeString = [dict valueStringForKey:r_statustype];
        self.statusType = [WhiteBoradStatusType getWhiteBoardStyle:statusTypeString];
        self.eventStatus = [dict valueStringForKey:r_statusName];
        
        self.showId = [dict valueStringForKey:r_taskId];
        self.title = [dict valueStringForKey:r_title];
        
        NSString *priorityString = [dict valueStringForKey:r_priority];
        self.priority = [WhiteBoradStatusType getMissionPriority:priorityString];
        
        self.deadlineDate = [dict valueDateForKey:r_endTime];
        if ([self.deadlineDate isEqualToDate:[NSDate dateWithTimeIntervalSince1970:0]]) {
            self.deadlineDate = nil;
        }
        
        if ([self.deadlineDate compare:[NSDate dateWithTimeIntervalSince1970:0]] == NSOrderedAscending) {
            self.deadlineDate = nil;
        }
        
        self.image = [dict valueStringForKey:r_image];
        self.isAnnex = [dict valueBoolForKey:r_isAnnex];
        self.finishedTask = [[dict valueNumberForKey:r_finishedTask] unsignedIntegerValue];
        self.allTask = [[dict valueNumberForKey:r_allTask] unsignedIntegerValue];
        
        self.level = [[dict valueNumberForKey:r_level] integerValue];
        self.parentTaskId = [dict valueStringForKey:r_parentTaskId];
        
        self.subMissionArray = [NSMutableArray array];
        
        self.arrayUser = [dict valueArrayForKey:r_userNames];
        self.arrayUserName = [dict valueArrayForKey:r_userTrueNames];
    }
    return self;
}

- (instancetype)initWithSubDict:(NSDictionary *)subDict {
    self = [super init];
    if (self) {
        self.image = [subDict valueStringForKey:r_imgLog];
        self.title = [subDict valueStringForKey:r_title];

        self.eventStatus = [subDict valueStringForKey:r_status];
        NSString *statusTypeString = [subDict valueStringForKey:r_stype];
        self.statusType = [WhiteBoradStatusType getWhiteBoardStyle:statusTypeString];
        
        NSString *priorityString = [subDict valueStringForKey:r_proiority];
        self.priority = [WhiteBoradStatusType getMissionPriority:priorityString];
        
        self.isAnnex = [subDict valueBoolForKey:r_t_isAnnex];
        self.showId = [subDict valueStringForKey:r_showId];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    return (
            [object isKindOfClass:[self class]] &&
            [[object showId] isEqualToString:self.showId]
            );
}

@end
