//
//  ApplyGetTotalCountRequest.m
//  launcher
//
//  Created by Kyle He on 15/9/23.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplyGetTotalCountRequest.h"
#import "ApplyGetReceiveListModel.h"
#import <DateTools.h>

static NSString *const apply_type = @"A_TYPE";
static NSString *const apply_pageIndex = @"pageIndex";
static NSString *const apply_pageSize = @"pageSize";
static NSString *const apply_timeStamp = @"timeStamp";
static NSString *const apply_IS_PROCESS = @"IS_PROCESS";

@implementation ApplyGetTotalCountResponse
@end

@implementation ApplyGetTotalCountRequest

- (void)GetType:(NSString *)type IS_PROCESS:(NSInteger)IS_PROCESS pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize timeStamp:(NSDate *)date
{
    self.params[apply_pageIndex] = @(pageIndex);
    self.params[apply_pageSize] = @(pageSize);
    self.params[apply_timeStamp] = @((long long)([[date dateByAddingMinutes:0] timeIntervalSince1970]*1000));
    self.params[apply_type] = type;
    self.params[apply_IS_PROCESS] = @(IS_PROCESS);
    [self requestData];
}

- (void)GetType:(NSString *)type IS_PROCESS:(NSInteger)IS_PROCESS pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    self.params[apply_pageIndex] = @(pageIndex);
    self.params[apply_pageSize] = @(pageSize);
    self.params[apply_type] = type;
    self.params[apply_IS_PROCESS] = @(IS_PROCESS);
    [self requestData];
}

- (NSString *)api {
    return @"/Approve-Module/Approve/GetApproveReceiveList";
}

- (NSString *)type {
    return @"GET";
}

- (BaseResponse *)prepareResponse:(id)data
{
    ApplyGetTotalCountResponse *response = [ApplyGetTotalCountResponse new];
    response.arrData = [[NSMutableArray alloc] initWithArray:((NSArray *)data)];
    return response;
}

@end
