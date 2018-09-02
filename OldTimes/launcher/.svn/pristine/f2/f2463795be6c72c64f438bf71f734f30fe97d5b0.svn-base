//
//  CreateWhiteboardRequest.h
//  launcher
//
//  Created by williamzhang on 15/11/6.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  创建白板Request

#import "BaseRequest.h"

@class TaskWhiteBoardModel;

@interface CreateWhiteboardResponse : BaseResponse

@property (nonatomic, strong) TaskWhiteBoardModel *whiteboardModel;

@end

@interface CreateWhiteboardRequest : BaseRequest

- (void)newWhiteboardName:(NSString *)whiteboardName fromProjectId:(NSString *)projectShowId;

@end
