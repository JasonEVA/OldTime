//
//  NewMissionUpdateTaskSortRequest.h
//  launcher
//
//  Created by Elliot on 8/4/16.
//  Copyright © 2016 William Zhang. All rights reserved.
//  新版任务排序更新请求

#import "BaseRequest.h"

@class TaskListModel;
@interface NewMissionUpdateTaskSortRequest : BaseRequest
- (void)sendUpdateSortTasksRequestWithTasks:(NSArray <TaskListModel *> *) tasks;

@end

@interface NewMissionUpdateTaskSortResponse : BaseResponse
@property (nonatomic, readwrite) TaskListModel *sortedTask;
@end