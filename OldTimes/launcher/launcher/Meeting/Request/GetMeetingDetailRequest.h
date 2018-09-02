//
//  GetMeetingDetailRequest.h
//  launcher
//
//  Created by Andrew Shen on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  会议详情接口

#import "BaseRequest.h"
#import "NewMeetingModel.h"

@interface GetMeetingDetailRequest : BaseRequest

- (void)getMeetingDetailWithShowID:(NSString *)showID startTime:(NSDate *)startTime;
@end

@interface GetMeetingDetailResponse : BaseResponse

@property (nonatomic, strong)  NewMeetingModel  *meetingModel; // 会议详情
@end