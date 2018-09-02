//
//  NewMissionUpdateTaskSortRequest.m
//  launcher
//
//  Created by Simon on 8/4/16.
//  Copyright © 2016 William Zhang. All rights reserved.
//

#import "NewMissionUpdateTaskSortRequest.h"
#import "TaskListModel.h"

static NSString* const NewMissionUpdateTaskSortRequestShowID = @"showId";
static NSString* const NewMissionUpdateTaskSortRequestExchangeShowID = @"exchangeShowId";
@interface NewMissionUpdateTaskSortRequest ()
@property (nonatomic, copy)NSArray<TaskListModel *> *tasks;
@end


@implementation NewMissionUpdateTaskSortRequest

- (NSString *)api {
	return @"/Task-Module/TaskV2/UpdateTaskSort";
}

- (NSString *)type {
	return @"Post";
}

- (void)sendUpdateSortTasksRequestWithTasks:(NSArray<TaskListModel *> *)tasks {
	if (!tasks) {
		return;
	} else {
		self.tasks = tasks;
	}
	
	self.params[NewMissionUpdateTaskSortRequestShowID] = self.showIDsFromTasks[0];
	self.params[NewMissionUpdateTaskSortRequestExchangeShowID] = self.showIDsFromTasks[1];
	[self requestData];
	
}

- (BaseResponse *)prepareResponse:(id)data {
	NewMissionUpdateTaskSortResponse *response = [NewMissionUpdateTaskSortResponse new];
	response.sortedTask = [[TaskListModel alloc] initWithDic:data];
	
	return response;
}

#pragma mark - Private Method
- (NSArray *)showIDsFromTasks {
	NSAssert(self.tasks.count <= 2, @"传排序的任务数组只需要两个元素");
	return [NSArray arrayWithObjects:self.tasks[0].showId, (self.tasks.count == 1 || [self.tasks[0] isChildOfTask:self.tasks[1]]) ? [NSNull null] : self.tasks[1].showId, nil];
}

@end

@interface NewMissionUpdateTaskSortResponse ()

@end
@implementation NewMissionUpdateTaskSortResponse


@end
