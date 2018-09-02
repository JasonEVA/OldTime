//
//  GetProjectListRequest.m
//  launcher
//
//  Created by William Zhang on 15/9/14.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "GetProjectListRequest.h"
#import "ProjectModel.h"

typedef NS_ENUM(NSUInteger, projectListStyle) {
    kProjectListStyleNew = 0,
    kProjectListStyleMore
};

@implementation GetProjectListResponse
@end

@interface GetProjectListRequest ()

@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, assign) projectListStyle style;

@end

static NSString * const d_pageIndex = @"pageIndex";
static NSString * const d_pageSize = @"pageSize";

static NSInteger const pageSize = 10;

@implementation GetProjectListRequest

- (void)getNewList {
    self.params[d_pageIndex] = @0;
    self.params[d_pageSize]  = @(pageSize);
    
    self.style = kProjectListStyleNew;
    [self requestData];
}

- (void)getMoreList {
    self.params[d_pageIndex] = @(self.pageIndex + 1);
    self.params[d_pageSize] = @(pageSize);

    self.style = kProjectListStyleMore;
    [self requestData];
}

- (NSString *)api { return @"/Task-Module/Task/GetProjectList";}
- (NSString *)type { return @"GET";}

- (BaseResponse *)prepareResponse:(id)data {
    self.pageIndex ++;
    if (self.style == kProjectListStyleNew) {
        self.pageIndex = 1;
    }
    
    GetProjectListResponse *response = [GetProjectListResponse new];
    
    NSMutableArray *arrayTmp = [NSMutableArray array];
    
    for (NSDictionary *dictProject in data) {
        if (!dictProject) {
            continue;
        }
        
        ProjectModel *project = [[ProjectModel alloc] initWithDict:dictProject];
        [arrayTmp addObject:project];
    }
    
    response.arrayProjects = [NSArray arrayWithArray:arrayTmp];
    return response;
}

@end
