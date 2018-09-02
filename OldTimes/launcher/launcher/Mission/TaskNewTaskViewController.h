//
//  TaskNewTaskViewController.h
//  launcher
//
//  Created by Conan Ma on 15/8/29.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  新建任务界面

#import "BaseViewController.h"

@class ProjectModel, MissionDetailModel;

@interface TaskNewTaskViewController : BaseViewController

- (instancetype)initWithTitle:(NSString *)title createNewTaskBlock:(void(^)(NSString *projectId))taskBlock;

- (instancetype)initWithMissionDetail:(MissionDetailModel *)detailModel editCompletion:(void(^)())completion;

// 聊天创建任务
- (instancetype)initWithDictModel:(NSMutableDictionary *)dictModel CreateNewTaskBlock:(void(^)(NSMutableDictionary *dictModel))taskBlock;

/** 父任务项目 */
@property (nonatomic, strong) ProjectModel *parentProject;

/** 父任务showId */
@property (nonatomic, copy) NSString *parentTaskShowId;

@end
