//
//  ApplyMessageRequest.m
//  launcher
//
//  Created by Conan Ma on 15/9/16.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyMessageRequest.h"
#import <DateTools.h>

static NSString *const msg_pageIndex = @"pageIndex";
static NSString *const msg_pageSize = @"pageSize";
static NSString *const msg_timeStamp = @"timeStamp";
static NSString *const msg_appShowID = @"appShowID";
static NSString *const msg_searchKey = @"searchKey";
static NSString *const msg_readStatus = @"readStatus";
static NSString *const msg_handleStatus = @"handleStatus";
static NSString *const msg_messageType = @"appMessageType";
static NSString *const msg_messageAppType = @"messageAppType";

@implementation ApplyMessageResponse

- (NSMutableArray *)arrMessageModel
{
    if (!_arrMessageModel)
    {
        _arrMessageModel = [[NSMutableArray alloc] init];
    }
    return _arrMessageModel;
}

@end

@implementation ApplyMessageRequest

- (void)GetDataWithtimeStamp:(NSDate *)timeStamp appShowID:(NSString *)appShowID searchKey:(NSString *)searchKey readStatus:(NSInteger)readStatus handleStatus:(NSInteger)handleStatus messageType:(NSString *)messageType messageAppType:(NSString *)messageAppType
{
    self.params[msg_pageIndex] = @(0);
    self.params[msg_timeStamp] = @([timeStamp timeIntervalSince1970] *1000);
    self.params[msg_readStatus] = @(readStatus);
    self.params[msg_messageType] = messageType;
}

- (void)GetUnreadMessagesWithpageIndex:(NSInteger)pageIndex timeStamp:(NSDate *)timeStamp appShowID:(NSString *)appShowID readStatus:(NSInteger)readStatus messageType:(NSString *)messageType
{
    self.params[msg_pageIndex] = @(pageIndex);
//    self.params[msg_timeStamp] = @(((long long)[timeStamp timeIntervalSince1970] *1000));
    self.params[msg_readStatus] = @(readStatus);
    self.params[msg_messageType] = messageType;
    self.params[msg_appShowID] = appShowID;
    self.params[msg_pageSize] = @(2);
//    self.params[msg_searchKey] = @"";
    [self requestData];
}

- (void)getMessageList {
    self.params[msg_appShowID] = @"ADWpPoQw85ULjnQk";
    self.params[msg_pageIndex] = @-1;
    self.params[msg_readStatus] = @0;
    self.params[@"messageAppTypes"] = @[@"APPROVAL_COMMENT", @"CC", @"SEND", @"APPROVE"];
    
    [self requestData];
}

- (NSString *)api
{
    return @"/Base-Module/Message/MessageList";
}

- (NSString *)type
{
    return @"GET";
}

- (BaseResponse *)prepareResponse:(id)data
{
    ApplyMessageResponse *response = [[ApplyMessageResponse alloc] init];
    if (data)
    {
        for (NSDictionary *dict in data)
        {
            ApplyMessageModel *model = [[ApplyMessageModel alloc] initWithDict:dict];
            [response.arrMessageModel addObject:model];
        }
    }
    return response;
}
@end
