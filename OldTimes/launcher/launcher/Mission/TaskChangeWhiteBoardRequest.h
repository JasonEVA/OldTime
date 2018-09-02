//
//  TaskChangeWhiteBoardRequest.h
//  launcher
//
//  Created by William Zhang on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  任务更新白板状态

#import "BaseRequest.h"

@interface TaskChangeWhiteBoardRequest : BaseRequest

- (void)changeTaskId:(NSString *)taskId whiteboardId:(NSString *)whiteboardId;

@end
