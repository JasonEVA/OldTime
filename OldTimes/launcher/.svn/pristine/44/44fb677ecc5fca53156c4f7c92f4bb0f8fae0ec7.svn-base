//
//  TaskDeleteRequest.h
//  launcher
//
//  Created by William Zhang on 15/9/16.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  任务删除

#import "BaseRequest.h"

typedef NS_ENUM(NSUInteger, TaskDeleteType) {
    kTaskDeleteTypeMain,
    kTaskDeleteTypeSubMission,
};

@interface TaskDeleteRequest : BaseRequest

- (void)deleteTaskId:(NSString *)taskId;

/** 删除时判断是子任务删除还是父任务删除 */
@property (nonatomic, assign) TaskDeleteType deleteType;

@property (nonatomic, readonly) NSString *taskIdDeleted;

@end
