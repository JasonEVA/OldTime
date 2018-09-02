//
//  NewMissionChangeMissionStatusRequest.m
//  launcher
//
//  Created by jasonwang on 16/2/20.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMissionChangeMissionStatusRequest.h"
#import "NSDictionary+SafeManager.h"

@implementation NewMissionChangeMissionStatusRequest
- (NSString *)api { return @"/Task-Module/TaskV2/TaskChangeStatus";}
- (NSString *)type { return @"POST";}

- (void)requestWithShowID:(NSString *)ShowID status:(NSString *)status
{
    self.params[@"showId"] = ShowID;
    self.params[@"sType"] = status;
    [super requestData];
}

- (BaseResponse *)prepareResponse:(id)data {
    NewMissionChangeMissionStatusResponse *response = [NewMissionChangeMissionStatusResponse new];
    response.isSuccess = [[data valueStringForKey:@"isSuccess"] intValue];
    response.path = self.path;
    response.type = self.status;
    return response;
}

@end

@implementation NewMissionChangeMissionStatusResponse

@end
