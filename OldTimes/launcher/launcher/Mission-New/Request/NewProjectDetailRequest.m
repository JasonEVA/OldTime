//
//  NewProjectDetailRequest.m
//  launcher
//
//  Created by jasonwang on 16/2/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewProjectDetailRequest.h"


static NSString * const d_showId = @"showId";

@implementation NewProjectDetailResponse
@end

@implementation NewProjectDetailRequest

- (NSString *)api  { return @"/Task-Module/TaskV2/GetProjectDetail";}
- (NSString *)type { return @"GET";}

- (void)detailShowId:(NSString *)showId {
    self.params[d_showId] = showId;
    [self requestData];
}

- (BaseResponse *)prepareResponse:(id)data {
    NewProjectDetailResponse *response = [NewProjectDetailResponse new];
    response.model = [[ProjectDetailModel alloc] initWithDic:data];
    return response;
}

@end