//
//  GetMeetingRoomRequest.m
//  launcher
//
//  Created by Andrew Shen on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "GetMeetingRoomRequest.h"
#import "MeetingRoomListModel.h"

@implementation GetMeetingRoomRequest

- (void)getMeetingRoomList {
    [self requestData];
}

- (NSString *)api {
    return @"/Schedule-Module/Meeting/GetMeetingRoom";
}

- (NSString *)type {
    return @"GET";
}

- (BaseResponse *)prepareResponse:(id)data {
    GetMeetingRoomResponse *response = [GetMeetingRoomResponse new];
    NSMutableArray *arrayTemp = [NSMutableArray array];
    for (NSDictionary *dict in data) {
        MeetingRoomListModel *model = [[MeetingRoomListModel alloc] initWithDict:dict];
        [arrayTemp addObject:model];
    }
    response.arrayRoomList = [arrayTemp mutableCopy];
    return response;
}
@end

@implementation GetMeetingRoomResponse

@end