//
//  ApplicationCommentDeleteRequest.m
//  launcher
//
//  Created by williamzhang on 15/11/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplicationCommentDeleteRequest.h"

static NSString * const d_showId = @"showID";

@implementation ApplicationCommentDeleteRequest

- (NSString *)api  { return @"/Base-Module/Comment";}
- (NSString *)type { return @"DELETE";}

- (void)deleteShowId:(NSString *)showId {
    self.params[d_showId] = showId;
    [self requestData];
}

@end
