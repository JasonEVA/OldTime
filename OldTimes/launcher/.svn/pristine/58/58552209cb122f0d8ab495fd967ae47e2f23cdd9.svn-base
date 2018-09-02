//
//  ApplicationCommentListRequest.m
//  launcher
//
//  Created by williamzhang on 15/11/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplicationCommentListRequest.h"
#import "ApplicationCommentModel.h"

static NSString * const d_appShowId = @"appShowID";
static NSString * const d_rmShowId  = @"rm_ShowID";
static NSString * const d_pageIndex = @"pageIndex";
static NSString * const d_timeStamp = @"timeStamp";
static NSString * const d_pageSize  = @"pageSize";

static NSInteger pageSize = 20;

@implementation ApplicationCommentListResponse
@end

@interface ApplicationCommentListRequest()

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL getNewList;

@end

@implementation ApplicationCommentListRequest

- (NSString *)api  { return @"/Base-Module/Comment/GetList";}
- (NSString *)type { return @"GET";}

- (void)setAppShowId:(NSString *)appShowId {
    self.params[d_appShowId] = appShowId;
}

- (void)newCommentWithShowId:(NSString *)showId {
    self.params[d_rmShowId]  = showId;

    self.params[d_pageIndex] = @(-1);
//    self.params[d_pageSize]  = @(pageSize);
    self.getNewList = YES;
    
    [self requestData];
}

- (void)getMoreWithTime:(NSDate *)date {
    self.params[d_timeStamp] = @([date timeIntervalSince1970] * 1000) ?:@"";
    self.params[d_pageIndex] = @(self.pageIndex);
    
    [self requestData];
}

- (BaseResponse *)prepareResponse:(id)data {
    ApplicationCommentListResponse *response = [ApplicationCommentListResponse new];
    
    self.pageIndex ++;
    if (self.getNewList) {
        self.pageIndex = 2;
        self.getNewList = NO;
    }
    
    NSMutableArray *arrayTmp = [NSMutableArray array];
    for (NSDictionary *dictComment in data) {
        if (!dictComment) {
            continue;
        }
        
        ApplicationCommentModel *commentModel = [[ApplicationCommentModel alloc] initWithDict:dictComment];
        [arrayTmp addObject:commentModel];
    }
    
    response.remain = [arrayTmp count] >= pageSize;
    response.arrayComments = [arrayTmp reverseObjectEnumerator].allObjects;
    return response;
}

@end
