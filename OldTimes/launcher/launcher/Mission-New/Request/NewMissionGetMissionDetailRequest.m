//
//  NewMissionGetMissionDetailRequest.m
//  launcher
//
//  Created by jasonwang on 16/2/19.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMissionGetMissionDetailRequest.h"

@implementation NewMissionGetMissionDetailResponse
@end

@implementation NewMissionGetMissionDetailRequest

- (void)getDetailTaskWithId:(NSString *)taskId {
    self.params[@"showId"] = taskId;
    [self requestData];
}

- (NSString *)api { return @"/Task-Module/TaskV2/TaskGet";}
- (NSString *)type { return @"GET";}

- (BaseResponse *)prepareResponse:(id)data {
    NewMissionGetMissionDetailResponse *response = [NewMissionGetMissionDetailResponse new];
    
    response.detailModel = [[NewMissionDetailModel alloc] initWithDic:data];
    
    return response;
}

@end
