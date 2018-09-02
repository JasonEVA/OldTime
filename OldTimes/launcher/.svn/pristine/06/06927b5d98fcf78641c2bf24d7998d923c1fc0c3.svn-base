//
//  GetUnfreeMeetingRoomList.h
//  launcher
//
//  Created by Andrew Shen on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
// 非空闲会议室请求

#import "BaseRequest.h"

@interface GetUnfreeMeetingRoomListRequest : BaseRequest
- (void)GetUnfreeRoomListWithStartTime:(long long)startTime endTime:(long long)endTime;
@end

@interface GetUnfreeMeetingRoomListResponse : BaseResponse
@property (nonatomic, copy)  NSArray  *arrayUnfreeRoomList; // 非空闲会议室列表数据<model>

@end
