//
//  TaskCreateAndEditDefine.h
//  launcher
//
//  Created by William Zhang on 15/9/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  新建、编辑任务request使用

#ifndef launcher_TaskCreateAndEditDefine_h
#define launcher_TaskCreateAndEditDefine_h

typedef NS_ENUM(NSUInteger, TaskCreateAndEditRequestType) {
    kTaskCreateAndEditRequestTypeTitle = 0,
    kTaskCreateAndEditRequestTypeComment,
    kTaskCreateAndEditRequestTypeStartTime,
    kTaskCreateAndEditRequestTypeDeadline,
    kTaskCreateAndEditRequestTypePeople,
    kTaskCreateAndEditRequestTypePriority,
    kTaskCreateAndEditRequestTypeProject,
    kTaskCreateAndEditRequestTypeTag,
    kTaskCreateAndEditRequestTypeRemind,
    kTaskCreateAndEditRequestTypeAttach,
    kTaskCreateAndEditRequestTypeRepeat,
    kTaskCreateAndEditRequestTypeParentShowId,
    kTaskCreateAndEditRequestTypeShowId,
    kTaskCreateAndEditRequestTypeId,                    // 任务Id
    kTaskCreateAndEditRequestTypeIsStartTimeAllDay,
    kTaskCreateAndEditRequestTypeIsEndTimeAllDay,
};

#endif
