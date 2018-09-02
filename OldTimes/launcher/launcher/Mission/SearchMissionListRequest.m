//
//  SearchMissionListRequest.m
//  launcher
//
//  Created by William Zhang on 15/9/14.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "SearchMissionListRequest.h"
#import "MissionMainViewModel.h"

@implementation SearchMissionListResponse
@end

static NSString * const d_type       = @"type";
static NSString * const d_pageIndex  = @"pageIndex";
static NSString * const d_statusType = @"statusType";
static NSString * const d_pageSize   = @"pageSize";

typedef NS_ENUM(NSUInteger, SearchRequestType) {
    kSearchRequestTypeNew,
    kSearchRequestTypeMore,
};

@interface SearchMissionListRequest ()

/** 初始化为1 */
@property (nonatomic, assign) NSUInteger pageIndex;

@property (nonatomic, assign) SearchRequestType searchType;

@end

static NSUInteger const pageSize = 20;

@implementation SearchMissionListRequest

- (NSUInteger)indexPage { return self.pageIndex;};

- (void)searchMoreTaskList {
    self.searchType = kSearchRequestTypeMore;
    [self searchTaskListWithType:[[self.params objectForKey:d_type] unsignedIntegerValue] pageIndex:self.pageIndex];
}

- (void)searchTaskListRefresh {
    self.searchType = kSearchRequestTypeNew;
    [self searchTaskListWithType:[[self.params objectForKey:d_type] unsignedIntegerValue] pageIndex:1];
}

- (void)searchTaskListWithType:(ProjectSearchType)type {
    self.searchType = kSearchRequestTypeNew;
    [self searchTaskListWithType:type pageIndex:1];
}

- (void)searchTaskListWithType:(ProjectSearchType)type pageIndex:(NSUInteger)pageIndex {
    self.params[d_type] = @(type);
    
    self.pageIndex = pageIndex;
    if (self.pageIndex == 0) {
        self.pageIndex = 1;
    }
    
    self.params[d_pageSize] = @(pageSize);
    self.params[d_pageIndex] = @(self.pageIndex);
    self.params[d_statusType] = @"Wating"; // 暂时写死
    
    [self requestData];
}

- (NSString *)api  { return @"/Task-Module/Task/GetTaskList";}
- (NSString *)type { return @"GET";}

- (BaseResponse *)prepareResponse:(id)data {
    self.pageIndex ++;
    if (self.searchType == kSearchRequestTypeNew) {
        self.pageIndex = 2;
    }
    
    SearchMissionListResponse *response = [SearchMissionListResponse new];
    
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
