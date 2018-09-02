//
//  TaskDeleteRequest.m
//  launcher
//
//  Created by William Zhang on 15/9/16.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "TaskDeleteRequest.h"

static NSString * const d_show_id = @"SHOW_ID";

@interface TaskDeleteRequest ()

@property (nonatomic, copy) NSString *showId;

@end

@implementation TaskDeleteRequest

- (void)deleteTaskId:(NSString *)taskId {
    self.showId = taskId;
    self.params[d_show_id] = taskId;
    [self requestData];
}

- (NSString *)api  { return @"/Task-Module/Task/DeleteTask";}
- (NSString *)type { return @"DELETE";}

- (NSString *)taskIdDeleted { return self.showId;}

@end
