//
//  DeleteWhiteboardRequest.m
//  launcher
//
//  Created by williamzhang on 15/11/6.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "DeleteWhiteboardRequest.h"

static NSString * const d_showId = @"showId";

@implementation DeleteWhiteboardRequest

- (void)deleteWhiteboardShowId:(NSString *)showId {
    self.params[d_showId]= showId;
    [self requestData];
}

- (NSString *)api  { return @"/Task-Module/Task/WhiteboardDelete";}
- (NSString *)type { return @"DELETE";}

@end
