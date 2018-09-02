//
//  MeetingNewRequest.h
//  launcher
//
//  Created by Lars Chen on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"
#import "NewMeetingModel.h"

@interface MeetingNewRequest : BaseRequest

- (void)newMeetingModel:(NewMeetingModel *)model;

@end

@interface MeetingNewResponse : BaseResponse

@property (nonatomic, strong) NewMeetingModel *meetingModel;

@end