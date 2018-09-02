//
//  NewGetProjectListRequest.m
//  launcher
//
//  Created by TabLiu on 16/2/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewGetProjectListRequest.h"


static NSString * const d_pageIndex = @"pageIndex";
static NSString * const d_pageSize = @"pageSize";

static NSInteger const pageSize = 10;

@implementation NewGetProjectListRequest

- (void)getNewList {
    self.params[d_pageIndex] = @0;
    self.params[d_pageSize]  = @(pageSize);
    
    [self requestData];
}

- (NSString *)api { return @"/Task-Module/TaskV2/GetProjectList";}
- (NSString *)type { return @"GET";}

- (BaseResponse *)prepareResponse:(id)data {
    
    NewGetProjectListResponse *response = [NewGetProjectListResponse new];
    response.isNeedDefine = YES;
    NSMutableArray *arrayTmp = [NSMutableArray array];
    
    for (NSDictionary *dictProject in data) {
        if (!dictProject) {
            continue;
        }
        ProjectContentModel *project = [[ProjectContentModel alloc] initWithDict:dictProject];
        if ([project.showId isEqualToString:self.seleShowId]) {
            response.isNeedDefine = NO;
        }
        [arrayTmp addObject:project];
    }
    response.dataArray = [NSMutableArray arrayWithArray:arrayTmp];
    return response;
}

@end


@implementation NewGetProjectListResponse


@end
