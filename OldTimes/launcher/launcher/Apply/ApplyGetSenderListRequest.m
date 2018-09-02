//
//  ApplyGetSenderListRequest.m
//  launcher
//
//  Created by Kyle He on 15/9/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyGetSenderListRequest.h"
#import <DateTools.h>

static NSString *const send_pageIndex = @"pageIndex";
static NSString *const send_pageSize = @"pageSize";
static NSString *const timeStamp = @"timeStamp";

@implementation ApplyGetSenderListRequest

- (void)getSenderListRequstWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)PageSize TimeStamp:(NSDate *)date 
{
    self.params[send_pageIndex] = @(pageIndex);
    self.params[send_pageSize] = @(PageSize);
    self.params[timeStamp] = @((long long)([[date dateByAddingMinutes:10] timeIntervalSince1970]*1000));
    [self requestData];
}

- (void)getSenderListRequstWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)PageSize
{
    self.params[send_pageIndex] = @(pageIndex);
    self.params[send_pageSize] = @(PageSize);
    [self requestData];
}

- (NSString *)api
{
    return @"/Approve-Module/Approve/GetApproveSendList";
}

- (NSString *)type
{
    return @"GET";
}

- (BaseResponse *)prepareResponse:(id)data
{
    ApplyGetSenderListResponse *reponse = [[ApplyGetSenderListResponse alloc] init];
    for (NSDictionary *dict in data)
    {
        ApplyGetReceiveListModel *model = [[ApplyGetReceiveListModel alloc] initWithDict:dict];
        [reponse.modelArr addObject:model];
    }
    return reponse;
}

@end

@implementation ApplyGetSenderListResponse
- (NSMutableArray *)modelArr
{
    if (!_modelArr)
    {
        _modelArr = [[NSMutableArray alloc] init];
    }
    return _modelArr;
}

@end