//
//  ApplyGetReceivedApplyListRequest.m
//  launcher
//
//  Created by Conan Ma on 15/9/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyGetReceivedApplyListRequest.h"
#import "ApplyGetReceiveListModel.h"
#import <DateTools.h>
@implementation ApplyGetReceivedApplyListResponse
@end

static NSString *const apply_type = @"A_TYPE";
static NSString *const apply_pageIndex = @"pageIndex";
static NSString *const apply_pageSize = @"pageSize";
static NSString *const apply_timeStamp = @"timeStamp";
static NSString *const apply_IS_PROCESS = @"IS_PROCESS";

@implementation ApplyGetReceivedApplyListRequest
//审批
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

//cc
- (void)GetType:(NSString *)type pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize timeStamp:(NSDate *)date
{
    self.params[apply_pageIndex] = @(pageIndex);
    self.params[apply_pageSize] = @(pageSize);
    self.params[apply_timeStamp] = @((long long)([[date dateByAddingMinutes:0] timeIntervalSince1970]*1000));
    self.params[apply_type] = type;
    [self requestData];
}

- (void)GetType:(NSString *)type pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    self.params[apply_pageIndex] = @(pageIndex);
    self.params[apply_pageSize] = @(pageSize);
    self.params[apply_type] = type;
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
    ApplyGetReceivedApplyListResponse *response = [ApplyGetReceivedApplyListResponse new];
    response.arrData = [[NSMutableArray alloc] initWithArray:((NSArray *)data)];
    return response;
}
@end
