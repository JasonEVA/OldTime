//
//  GetTaskDetailRequest.h
//  launcher
//
//  Created by William Zhang on 15/9/15.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  获取任务详情

#import "BaseRequest.h"

typedef NS_ENUM(NSUInteger, GetTaskDetailRequestType) {
    getTaskDetailRequestTypeNew = 0,
    getTaskDetailRequestTypeRefreshSubTask,
};

@class MissionDetailModel;

@interface GetTaskDetailResponse : BaseResponse
/** 详情时候用 */
@property (nonatomic, strong) MissionDetailModel *detailModel;

@end

@interface GetTaskDetailRequest : BaseRequest

- (void)getDetailTaskWithId:(NSString *)taskId;

/** 获取详情时的状态(详情界面只想刷新下子任务，不跟获取详情冲撞) */
@property (nonatomic, assign) GetTaskDetailRequestType detailType;


@end
