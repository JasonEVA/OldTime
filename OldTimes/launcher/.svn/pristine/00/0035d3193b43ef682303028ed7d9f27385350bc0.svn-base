//
//  GetTaskListRequest.h
//  launcher
//
//  Created by William Zhang on 15/9/15.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  获取单个项目任务列表 (与`searchMissionListRequest`为同一个接口)

#import "BaseRequest.h"

@interface GetTaskListResponse : BaseResponse

@property (nonatomic, strong) NSArray *taskArray;

@end

@interface GetTaskListRequest : BaseRequest

@property (nonatomic, readonly) NSUInteger indexPage;

- (void)getMoreTaskList;
- (void)getTaskListRefresh;
- (void)getTaskListWithWhiteBoardId:(NSString *)whiteBoardId pageIndex:(NSUInteger)pageIndex;

@end
