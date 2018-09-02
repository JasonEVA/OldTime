//
//  CreateWhiteboardRequest.m
//  launcher
//
//  Created by williamzhang on 15/11/6.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "CreateWhiteboardRequest.h"
#import "TaskWhiteBoardModel.h"

static NSString * const d_pShowId = @"pShowId";
static NSString * const d_name    = @"name";

@implementation CreateWhiteboardResponse
@end

@implementation CreateWhiteboardRequest

- (void)newWhiteboardName:(NSString *)whiteboardName fromProjectId:(NSString *)projectShowId {
    self.params[d_pShowId] = projectShowId;
    self.params[d_name]    = whiteboardName;
    
    [self requestData];
}

- (NSString *)api  { return @"/Task-Module/Task/WhiteboardAdd";}
- (NSString *)type { return @"PUT";}

- (BaseResponse *)prepareResponse:(id)data {
    CreateWhiteboardResponse *response = [CreateWhiteboardResponse new];
    response.whiteboardModel = [[TaskWhiteBoardModel alloc] initWithDict:data];
    return response;
}

@end
