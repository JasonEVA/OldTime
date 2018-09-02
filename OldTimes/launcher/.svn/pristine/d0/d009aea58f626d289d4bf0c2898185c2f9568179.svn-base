//
//  GetProjectListRequest.h
//  launcher
//
//  Created by William Zhang on 15/9/14.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  获取项目列表

#import "BaseRequest.h"

@interface GetProjectListResponse : BaseResponse

@property (nonatomic, strong) NSArray *arrayProjects;

@end

/**
 *  pageIndex小于1获取所有项目
 */
@interface GetProjectListRequest : BaseRequest

- (void)getNewList;
- (void)getMoreList;

@end
