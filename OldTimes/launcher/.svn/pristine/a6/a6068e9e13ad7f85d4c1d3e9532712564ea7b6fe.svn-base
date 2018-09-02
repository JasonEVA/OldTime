//
//  SearchMissionListRequest.h
//  launcher
//
//  Created by William Zhang on 15/9/14.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  搜索及获取任务列表Request

#import "BaseRequest.h"
#import "ProjectSearchDefine.h"

@interface SearchMissionListResponse : BaseResponse

@property (nonatomic, strong) NSArray *taskArray;

@end

@interface SearchMissionListRequest : BaseRequest

@property (nonatomic, readonly) NSUInteger indexPage;

/**
 *  先使用后2条的一条定义type后使用，直接使用type为projectSearchTypeAll
 */
- (void)searchMoreTaskList;
/** 重新获取 */
- (void)searchTaskListRefresh;
- (void)searchTaskListWithType:(ProjectSearchType)type;

@end
