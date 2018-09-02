//
//  TaskChangeWhiteBoardRequest.m
//  launcher
//
//  Created by William Zhang on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "TaskChangeWhiteBoardRequest.h"

static const NSString * d_showId     = @"SHOW_ID";
static const NSString * d_s_showId   = @"S_SHOW_ID";
static const NSString * d_updateType = @"UpdateType";

@implementation TaskChangeWhiteBoardRequest

- (void)changeTaskId:(NSString *)taskId whiteboardId:(NSString *)whiteboardId {
    self.params[d_showId] = taskId;
    self.params[d_s_showId] = whiteboardId;
    self.params[d_updateType] = @3;
    
    [self requestData];
}

- (NSString *)api { return @"/Task-Module/Task/UpdateTask";}

@end
