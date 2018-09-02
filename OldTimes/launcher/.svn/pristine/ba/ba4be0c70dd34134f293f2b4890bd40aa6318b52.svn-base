//
//  GetWhiteBoardListRequest.m
//  launcher
//
//  Created by William Zhang on 15/9/14.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "GetWhiteBoardListRequest.h"
#import "TaskWhiteBoardModel.h"

@implementation GetWhiteBoardListResponse
@end

static NSString * const d_showId = @"showId";

@implementation GetWhiteBoardListRequest

- (void)getProjectWhiteBoard:(NSString *)projectShowId {
    self.params[d_showId] = projectShowId ?:@"";
    [self requestData];
}

- (NSString *)api {return @"/Task-Module/Task/GetWhiteBoardList";}
- (NSString *)type { return @"GET";}

- (BaseResponse *)prepareResponse:(id)data {
    GetWhiteBoardListResponse *response = [GetWhiteBoardListResponse new];
    
    NSMutableArray *arrayTmp = [NSMutableArray array];
    
    for (NSDictionary *dictWhiteBoard in data) {
        if (!dictWhiteBoard) {
            continue;
        }
        
        TaskWhiteBoardModel *whiteBoard = [[TaskWhiteBoardModel alloc] initWithDict:dictWhiteBoard];
        [arrayTmp addObject:whiteBoard];
    }
    
    response.arrayWhiteBoard = [NSArray arrayWithArray:arrayTmp];
    [response setValue:self.params[d_showId] forKey:@"projectShowId"];
    return response;
}

@end
