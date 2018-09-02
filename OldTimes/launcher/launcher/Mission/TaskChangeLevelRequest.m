//
//  TaskChangeLevelRequest.m
//  launcher
//
//  Created by William Zhang on 15/9/18.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "TaskChangeLevelRequest.h"

static NSString * const d_showId     = @"SHOW_ID";
static NSString * const d_updateType = @"UpdateType";

@implementation TaskChangeLevelRequest

- (void)changeLevelShowId:(NSString *)taskShowId index:(NSUInteger)index {
    _index = index;
    
    self.params[d_showId]     = taskShowId;
    self.params[d_updateType] = @1;
    [self requestData];
}

- (NSString *)api { return @"/Task-Module/Task/UpdateTask";}

@end
