//
//  MeetingGetPeopleUnFreeListRequest.m
//  launcher
//
//  Created by William Zhang on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingGetPeopleUnFreeListRequest.h"
#import "NSDictionary+SafeManager.h"

static NSString *const d_user      = @"user";
static NSString *const d_startTime = @"startTime";
static NSString *const d_endTime   = @"endTime";

static NSString *const r_unFreeTimeList = @"unFreeTimeList";
static NSString *const r_result = @"result";

@implementation MeetingGetPeopleUnFreeListResponse
@end

@implementation MeetingGetPeopleUnFreeListRequest

- (void)userNameList:(NSArray *)nameList startTime:(NSDate *)startTime endTime:(NSDate *)endTime {
    self.params[d_user] = [self nameEdit:nameList];
    
    long startInterval = [startTime timeIntervalSince1970];
    long endInterval   = [endTime timeIntervalSince1970];
    
    self.params[d_startTime] = @(startInterval);
    self.params[d_endTime]   = @(endInterval);
    
    [self requestData];
}

- (NSString *)api {
    return @"/Schedule-Module/Schedule/GetUnFreeMeetingList";
}

- (NSString *)type {
    return @"GET";
}

- (BaseResponse *)prepareResponse:(id)data {
    MeetingGetPeopleUnFreeListResponse *response = [MeetingGetPeopleUnFreeListResponse new];
    
    NSMutableArray *arrayTmp = [NSMutableArray array];
    
    // 特殊返回data（数组）
    for (NSDictionary *dictUnFreeList in data) {
        if (!dictUnFreeList) {
            continue;
        }
        
        NSArray *arrUnFreeList = [dictUnFreeList valueArrayForKey:r_unFreeTimeList];
        
        for (NSDictionary *dictUnFree in arrUnFreeList) {
            NSNumber *boolNumber = [dictUnFree valueNumberForKey:r_result];
            if ([boolNumber boolValue]) { // true -> 空闲时间
                continue;
            }
            
            long long startInterval = [[dictUnFree valueNumberForKey:d_startTime] longLongValue];
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startInterval / 1000];
            
            [arrayTmp addObject:startDate];
        }
    }
    
    response.arrayUnFreeList = [NSArray arrayWithArray:arrayTmp];
    
    return response;
}

#pragma mark - Private Method
- (NSString *)nameEdit:(NSArray *)nameList {
    return [nameList componentsJoinedByString:@"●"];
}

@end
