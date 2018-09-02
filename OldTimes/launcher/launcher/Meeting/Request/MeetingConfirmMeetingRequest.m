//
//  MeetingConfirmMeetingRequest.m
//  launcher
//
//  Created by Conan Ma on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingConfirmMeetingRequest.h"

@implementation MeetingConfirmMeetingRequest

static NSString *const M_SHOW_ID  = @"M_SHOW_ID";
static NSString *const O_IS_AGREE = @"O_IS_AGREE";
static NSString *const O_REASON   = @"O_REASON";

- (void)ConfirmWhetherAttendWith:(NSString *)ShowID WhetherAgree:(NSInteger)Agree Reason:(NSString *)Reason {
    self.params[M_SHOW_ID] = ShowID;
    self.params[O_IS_AGREE] = @(Agree);
    self.params[O_REASON] = Reason ?:@" ";
    
    [self requestData];
}

- (NSString *)api {
    return @"/Schedule-Module/Meeting/MeetingConfirm";
}

@end