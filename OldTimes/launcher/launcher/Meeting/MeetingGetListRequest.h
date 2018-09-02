//
//  MeetingGetListRequest.h
//  launcher
//
//  Created by William Zhang on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  获取会议列表

#import "BaseRequest.h"

@interface MeetingGetListResponse : BaseResponse

/** 会议列表 （CalendarLaunchrModel） */
@property (nonatomic, strong) NSArray *meetingList;

@end

@interface MeetingGetListRequest : BaseRequest

- (void)meetingListWithUser:(NSString *)userName startTime:(NSDate *)startTime endTime:(NSDate *)endTime;

@end
