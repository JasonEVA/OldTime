//
//  TaskCreateRequest.h
//  launcher
//
//  Created by William Zhang on 15/9/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  新建任务

#import "BaseRequest.h"
#import "TaskCreateAndEditDefine.h"

@interface TaskCreateResponse : BaseResponse

@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *showId;

@end

@interface TaskCreateRequest : BaseRequest

- (void)createTask:(NSDictionary *)dict parentId:(NSString *)parentId;

@end
