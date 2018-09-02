//
//  MeetingConfirmMeetingRequest.h
//  launcher
//
//  Created by Conan Ma on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@interface MeetingConfirmMeetingRequest : BaseRequest

- (void)ConfirmWhetherAttendWith:(NSString *)ShowID WhetherAgree:(NSInteger)Agree Reason:(NSString *)Reason;

@end
