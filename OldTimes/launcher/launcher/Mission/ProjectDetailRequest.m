//
//  ProjectDetailRequest.m
//  launcher
//
//  Created by williamzhang on 15/11/11.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ProjectDetailRequest.h"
#import "ProjectModel.h"

static NSString * const d_showId = @"showId";

@implementation ProjectDetailResponse
@end

@implementation ProjectDetailRequest

- (NSString *)api  { return @"/Task-Module/Task/GetProjectDetail";}
- (NSString *)type { return @"GET";}

- (void)detailShowId:(NSString *)showId {
    self.params[d_showId] = showId;
    [self requestData];
}

- (BaseResponse *)prepareResponse:(id)data {
    ProjectDetailResponse *response = [ProjectDetailResponse new];
    
    response.project = [[ProjectModel alloc] initWithDict:data];
    
    return response;
}

@end
