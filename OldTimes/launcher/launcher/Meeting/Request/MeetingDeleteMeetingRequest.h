//
//  MeetingDeleteMeetingRequest.h
//  launcher
//
//  Created by Conan Ma on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"
@interface MeetingDeleteMeetingResponse : BaseResponse

@end

@interface MeetingDeleteMeetingRequest : BaseRequest

- (void)deleteSheduleByShowId:(NSString *)showId InitialStartTime:(long long)initialStartTime SaveType:(NSInteger)savetype;

@end
