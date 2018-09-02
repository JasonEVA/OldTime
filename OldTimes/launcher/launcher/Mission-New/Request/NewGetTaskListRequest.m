       //
//  NewGetTaskListRequest.m
//  launcher
//
//  Created by TabLiu on 16/2/16.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewGetTaskListRequest.h"
#import "TaskListModel.h"

@implementation NewGetTaskListRequest

- (void)requestData
{
    [self.params setValue:_pageIndex        forKey:@"pageIndex"];
    [self.params setValue:@10       forKey:@"pageSize"];
    [self.params setValue:_Type     forKey:@"type"];
    if (_time != 0) {
        [self.params setValue:@(_time)     forKey:@"time"];
    }
    if (![_statusType isEqualToString:@""]) {
        [self.params setValue:_statusType forKey:@"statusType"];
    }
    if (![_projectId isEqualToString:@""]) {
        [self.params setValue:_projectId forKey:@"projectId"];
    }
    [super requestData];
}
- (void)search
{
    _isSearch = YES;
    [self.params setValue:@1        forKey:@"pageIndex"];
    [self.params setValue:@10       forKey:@"pageSize"];
    [self.params setValue:_Type     forKey:@"type"];
    [self.params setValue:@(_time)     forKey:@"time"];
    [self.params setValue:_searchKey forKey:@"searchKey"];
    [super requestData];
}

- (NSString *)api { return @"/Task-Module/TaskV2/GetTaskList";}
- (NSString *)type { return @"GET";}
- (BaseResponse *)prepareResponse:(id)data {
    NewGetTaskListResponse * response = [NewGetTaskListResponse new];
    response.NO_overdue_Array = [NSMutableArray array];
    response.overdue_Array = [NSMutableArray array];
    response.child_dict = [NSMutableDictionary dictionary];
    if ([self.Type intValue] != 2 && [self.Type intValue] < 6) {
        response.needDividDueTask = YES;
    }

    [response dealWithData:data];
    return response;
}

@end

@implementation NewGetTaskListResponse

- (void)dealWithData:(id)data
{
    self.child_dict = [NSMutableDictionary dictionary];
    self.NO_overdue_Array = [NSMutableArray array];
    self.overdue_Array  =[NSMutableArray array ];
    
    long long presentTime = [[NSDate date] timeIntervalSince1970] * 1000; // 当前时间
    
    NSMutableArray * child_Nooverdue_Array = [NSMutableArray array];// 未过期 的 子任务
    
    NSMutableArray * child_overdue_Array   = [NSMutableArray array];// 过期 的 子任务
    
    for (NSDictionary * dic in data){
        TaskListModel * model = [[TaskListModel alloc] initWithDic:dic];
        if (self.needDividDueTask) { // 需要区分是否过期
            if (model.endTime > 0 && model.endTime < presentTime) { //过期
                if (model.level == 1) {  // 根任务
                    [self.overdue_Array addObject:model];
                    
                }else {
                    [child_overdue_Array addObject:model];
                }
            }else {
                if (model.level == 1) {  // 根任务
                    [self.NO_overdue_Array addObject:model];
                }else {
                    [child_Nooverdue_Array addObject:model];
                }
            }
        }else { // 不需要区分是否已经过期
            if (model.level == 1) {  // 根任务
                [self.NO_overdue_Array addObject:model];
            }else {
                [child_Nooverdue_Array addObject:model];
            }
        }
    }
	
	if (self.needDividDueTask) {
		[self associatedModelWithRootArray:self.overdue_Array childArray:child_Nooverdue_Array];
	} else {
		[self associatedModelWithRootArray:self.NO_overdue_Array childArray:child_overdue_Array];
	}
	
	[self associatedModelWithRootArray:self.NO_overdue_Array childArray:child_Nooverdue_Array ];
	[self associatedModelWithRootArray:self.overdue_Array childArray:child_overdue_Array ];
}

- (void)associatedModelWithRootArray:(NSMutableArray *)rootArray childArray:(NSMutableArray *)childArray
{
    for (int i = 0; i < childArray.count; i ++ ) {
        TaskListModel * childModel = [childArray objectAtIndex:i];
        BOOL isHaveParent = NO; //是否有父任务 默认,无
        for (int j = 0; j < rootArray.count; j ++) {
            TaskListModel * rootModel = [rootArray objectAtIndex:j];
            
            if ([childModel.parentTaskId isEqualToString:rootModel.showId]) { // 是其子任务
                childModel.notNeedDisplacement = YES;
                NSArray * keyArray = [self.child_dict allKeys];
                if ([keyArray containsObject:childModel.parentTaskId]) { // 已存在
                    NSMutableArray * array = [self.child_dict objectForKey:childModel.parentTaskId];
                    [array addObject:childModel];
                    [self.child_dict setValue:array forKey:childModel.parentTaskId];
                }else {
                    NSMutableArray * array = [NSMutableArray array];
                    [array addObject:childModel];
                    [self.child_dict setValue:array forKey:childModel.parentTaskId];
                }
                rootModel.allTask += 1;
                if ([childModel.type isEqualToString:@"FINISH"]) {
                    rootModel.finishedTask += 1;
                }
                isHaveParent = YES; // 有
                // 跳出此次循环
            }
        }
        
    }
}


@end
