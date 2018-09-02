//
//  NewTaskCreateRequest.h
//  launcher
//
//  Created by jasonwang on 16/2/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
//   新建任务请求

#import "BaseRequest.h"
#import "TaskCreateAndEditDefine.h"

@interface NewTaskCreateResponse : BaseResponse

@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *showId;

@end

@interface NewTaskCreateRequest : BaseRequest

- (void)createTask:(NSDictionary *)dict parentId:(NSString *)parentId;

@end
