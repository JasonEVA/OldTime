//
//  MissionMainViewModel.h
//  launcher
//
//  Created by Kyle He on 15/9/1.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  任务model

#import <Foundation/Foundation.h>
#import "ProjectSearchDefine.h"

typedef NS_ENUM(NSUInteger, MissionTaskComment) {
    MissionTaskCommentNone = 0,
    MissionTaskCommentNormal,
    MissionTaskCommentNew,
};

@interface MissionMainViewModel : NSObject

@property (nonatomic, copy) NSString *image;
/** 项目ID */
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *projectName;

@property (nonatomic, copy) NSString *statusId;
/** 任务进度 */
@property (nonatomic, assign) whiteBoardStyle statusType;
/** 任务状态 */
@property(nonatomic, copy) NSString  *eventStatus;

@property (nonatomic, copy) NSString *showId;

@property(nonatomic, copy) NSString  *title;
/** 截止时间（⏰旁边那个） (可以nil)*/
@property(nonatomic, copy) NSDate  *deadlineDate;
/** 开始时间（⏰旁边那个） (可以nil)*/
@property(nonatomic, copy) NSDate  *startDate;
@property (nonatomic, assign) BOOL wholeDay;

/** 任务重要程度 */
@property(nonatomic) MissionTaskPriority priority;

@property (nonatomic, assign) MissionTaskComment commentStatus;

@property (nonatomic, assign) NSUInteger finishedTask;
@property (nonatomic, assign) NSUInteger allTask;
/** 是否有附件 */
@property (nonatomic, assign) BOOL isAnnex;

/** 子任务数组（MissionMainViewModel） */
@property (nonatomic, strong) NSMutableArray *subMissionArray;

/** 任务层级,从1开始,1=根任务,2=子任务 */
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, copy  ) NSString  *parentTaskId;

@property (nonatomic, copy) NSString *createrUser;
@property (nonatomic, copy) NSString *createrUserName;

/** 配合服务器暂时这么做（发布评论时用） */
@property (nonatomic, strong) NSArray *arrayUser;
@property (nonatomic, strong) NSArray *arrayUserName;

- (instancetype)initWithDict:(NSDictionary *)dict;

/** 详情中创建子任务 */
- (instancetype)initWithSubDict:(NSDictionary *)subDict;

@end
