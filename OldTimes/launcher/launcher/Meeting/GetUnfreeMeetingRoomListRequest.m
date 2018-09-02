//
//  GetUnfreeMeetingRoomList.m
//  launcher
//
//  Created by Andrew Shen on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "GetUnfreeMeetingRoomListRequest.h"
#import "UnfreeMeetingRoomModel.h"

#define Dict_startTime @"startTime"
#define Dict_endTime @"endTime"

@implementation GetUnfreeMeetingRoomListRequest

- (void)GetUnfreeRoomListWithStartTime:(long long)startTime endTime:(long long)endTime {
    self.params[Dict_startTime] = @(startTime);
    self.params[Dict_endTime] = @(endTime);
    [self requestData];
}

- (NSString *)type {
    return @"GET";
}

- (NSString *)api {
    return @"/Schedule-Module/Schedule/GetUnFreeMeetingRoomList";
}

- (BaseResponse *)prepareResponse:(id)data {
    GetUnfreeMeetingRoomListResponse *response = [GetUnfreeMeetingRoomListResponse new];
    NSMutableArray *arrayTemp = [NSMutableArray array];
    for (NSDictionary *dict in data) {
        UnfreeMeetingRoomModel *model = [[UnfreeMeetingRoomModel alloc] initWithDict:dict];
        [arrayTemp addObject:model];
    }
    response.arrayUnfreeRoomList = [arrayTemp mutableCopy];
    return response;
}
@end

@implementation GetUnfreeMeetingRoomListResponse



@end