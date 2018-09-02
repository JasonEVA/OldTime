//
//  NewMeetingCancelRequest.m
//  launcher
//
//  Created by 马晓波 on 16/3/24.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMeetingCancelRequest.h"
static NSString *const d_show_ID = @"showId";
static NSString *const d_reason = @"reason";


@implementation NewMeetingCancelRequest
- (void)getMeetingShowID:(NSString *)showid Reason:(NSString *)reason
{
    self.params[d_show_ID] = showid;
    self.params[d_reason] = reason;
    
    [self requestData];
}

- (NSString *)api
{
    return @"/Schedule-Module/Meeting/CancelMeeting";
}

- (NSString *)type
{
    return @"POST";
}

- (BaseResponse *)prepareResponse:(id)data {
    NewMeetingCancelResponse *response = [NewMeetingCancelResponse new];
    if ([data isKindOfClass:[NSDictionary class]]) {
        
    }
    
    return response;
}

@end

@implementation NewMeetingCancelResponse

@end