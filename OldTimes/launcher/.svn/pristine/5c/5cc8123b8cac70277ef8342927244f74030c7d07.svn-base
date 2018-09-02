//
//  TaskListModel.m
//  launcher
//
//  Created by TabLiu on 16/2/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "TaskListModel.h"
#import "NSDictionary+SafeManager.h"
#import <DateTools/DateTools.h>

@implementation TaskListModel

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _showId          = [dic valueStringForKey:@"showId"];
        _title           = [dic valueStringForKey:@"title"];
        _endTime         = [[dic valueStringForKey:@"endTime"] longLongValue];
        _isEndTimeAllDay = [[dic valueStringForKey:@"isEndTimeAllDay"] intValue];
        _userName        = [dic valueStringForKey:@"userName"];
        _userTrueName    = [dic valueStringForKey:@"userTrueName"];
        _priority        = [dic valueStringForKey:@"priority"];
        _type            = [dic valueStringForKey:@"type"];
        _isAnnex         = [[dic valueStringForKey:@"isAnnex"] intValue];
        _isComment       = [[dic valueStringForKey:@"isComment"] intValue];
        _level           = [[dic valueStringForKey:@"level"] intValue];
        _parentTaskId    = [dic valueStringForKey:@"parentTaskId"];
        _projectId       = [dic valueStringForKey:@"projectId"];
        _projectName     = [dic valueStringForKey:@"projectName"];
        _finishedTask    = [[dic valueStringForKey:@"finishedTask"] intValue];
        _allTask         = [[dic valueStringForKey:@"allTask"] intValue];

        _startTime = [[dic valueNumberForKey:@"startTime"] longLongValue];
        _isStartTimeAllDay = [[dic valueNumberForKey:@"isStartAllDay"] intValue];
        
        if (_isStartTimeAllDay && _startTime > 0) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:_startTime/1000];
            NSDate *newDate = [NSDate dateWithYear:date.year month:date.month day:date.day hour:23 minute:59 second:59];
            _startTime = [newDate timeIntervalSince1970] * 1000;
        }
        
        if (_isEndTimeAllDay && _endTime > 0) {
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:_endTime/1000];
            NSDate * newDate = [NSDate dateWithYear:date.year month:date.month day:date.day hour:23 minute:59 second:59];
            _endTime = [newDate timeIntervalSince1970] * 1000;
        }
        
    }
    return self;
}

#pragma mark - Interface Method
- (BOOL)hasSameParentWithTask:(TaskListModel *)task {
	return self.parentTaskId && task.parentTaskId && ([self.parentTaskId isEqualToString:task.parentTaskId] && ![self.parentTaskId isEqualToString:@"" ]);
	
}

- (BOOL)isChildOfTask:(TaskListModel *)task {
	return self.parentTaskId && ![self.parentTaskId isEqualToString:@""] && [self.parentTaskId isEqualToString:task.showId];
}

- (BOOL)hasParentTask {
	return self.parentTaskId && ![self.parentTaskId isEqualToString:@""];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"title:%@, id:%@", self.title, self.showId];
}
@end
