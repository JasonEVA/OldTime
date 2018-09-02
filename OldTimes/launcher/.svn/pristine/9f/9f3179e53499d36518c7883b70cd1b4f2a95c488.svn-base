//
//  GetTaskDetailRequest.m
//  launcher
//
//  Created by William Zhang on 15/9/15.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "GetTaskDetailRequest.h"
#import "MissionDetailModel.h"

@implementation GetTaskDetailResponse
@end

@implementation GetTaskDetailRequest

- (void)getDetailTaskWithId:(NSString *)taskId {
    self.params[@"showId"] = taskId;
    [self requestData];
}

- (NSString *)api { return @"/Task-Module/TaskV2/TaskGet";}
- (NSString *)type { return @"GET";}

- (BaseResponse *)prepareResponse:(id)data {
    GetTaskDetailResponse *response = [GetTaskDetailResponse new];
    
    response.detailModel = [[MissionDetailModel alloc] initWithDict:data];
    
    return response;
}

@end
