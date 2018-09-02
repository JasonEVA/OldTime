//
//  GetTaskListRequest.m
//  launcher
//
//  Created by William Zhang on 15/9/15.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "GetTaskListRequest.h"
#import "MissionMainViewModel.h"
#import "ProjectSearchDefine.h"

@implementation GetTaskListResponse
@end

static NSString * const d_type      = @"type";
static NSString * const d_statusId  = @"statusId";
static NSString * const d_pageIndex = @"pageIndex";
static NSString * const d_pageSize  = @"pageSize";

typedef NS_ENUM(NSUInteger, GetTaskRequestType) {
    kGetTaskRequestTypeNew = 0,
    kGetTaskRequestTypeMore,
};

@interface GetTaskListRequest ()

@property (nonatomic, assign) NSUInteger pageIndex;

@property (nonatomic, assign) GetTaskRequestType taskType;

@end

static NSUInteger const pageSize = 20;

@implementation GetTaskListRequest

- (instancetype)initWithDelegate:(id<BaseRequestDelegate>)delegate {
    self = [super initWithDelegate:delegate];
    if (self) {
        self.params[d_type] = @(projectSearchTypeOneWhiteBoard);
        self.params[d_pageSize] = @(pageSize);
    }
    return self;
}

- (NSUInteger)indexPage { return self.pageIndex;}

- (void)getMoreTaskList {
    self.taskType = kGetTaskRequestTypeMore;
    [self getTaskListWithWhiteBoardId:self.params[d_statusId] pageIndex:self.pageIndex];
}

- (void)getTaskListRefresh {
    self.taskType = kGetTaskRequestTypeNew;
    [self getTaskListWithWhiteBoardId:self.params[d_statusId] pageIndex:1];
}
- (void)getTaskListWithWhiteBoardId:(NSString *)whiteBoardId pageIndex:(NSUInteger)pageIndex {
    self.taskType = kGetTaskRequestTypeMore;
    self.params[d_statusId] = whiteBoardId ?:@"";
    
    self.pageIndex = pageIndex;
    if (self.pageIndex == 0) {
        self.pageIndex = 1;
    }
    
    self.params[d_pageIndex] = @(self.pageIndex);
    [self requestData];
}

- (NSString *)api  { return @"/Task-Module/Task/GetTaskList";}
- (NSString *)type { return @"GET";}

- (BaseResponse *)prepareResponse:(id)data {
    self.pageIndex ++;
    if (self.taskType == kGetTaskRequestTypeNew) {
        self.pageIndex = 2;
    }
    
    GetTaskListResponse *response = [GetTaskListResponse new];
    
    NSMutableArray *arrayTmp = [NSMutableArray array];      // 暂时存储2级数据
    NSMutableArray *arrayFirst = [NSMutableArray array];    // 1级父目录
    
    for (NSDictionary *missionDict in data) {
        if (!missionDict) {
            continue;
        }
        
        MissionMainViewModel *model = [[MissionMainViewModel alloc] initWithDict:missionDict];
        if (model.level == 1) {
            [arrayFirst addObject:model];
        }
        else {
            [arrayTmp addObject:model];
        }
    }
    
    for (MissionMainViewModel *secondModel in arrayTmp) {
        for (MissionMainViewModel *firstModel in arrayFirst) {
            if (![firstModel.showId isEqualToString:secondModel.parentTaskId]) {
                continue;
            }
            
            [firstModel.subMissionArray addObject:secondModel];
            break;
        }
    }
    
    response.taskArray = [NSArray arrayWithArray:arrayFirst];
    return response;
}

@end
