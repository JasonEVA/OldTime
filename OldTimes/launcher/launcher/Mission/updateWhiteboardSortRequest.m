//
//  updateWhiteboardSortRequest.m
//  launcher
//
//  Created by williamzhang on 15/11/6.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "updateWhiteboardSortRequest.h"

static NSString * const d_showId = @"showId";
static NSString * const d_prevShowId = @"prevShowId";

@implementation updateWhiteboardSortRequest

- (void)beforeUpdateIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _fromIndex = fromIndex;
    _toIndex   = toIndex;
}

- (void)updateWhiteboardSort:(NSString *)showId previousBoardShowId:(NSString *)prevShowId {
    self.params[d_showId]     = showId;
    self.params[d_prevShowId] = prevShowId;
    [self requestData];
}

- (NSString *)api { return @"/Task-Module/Task/WhiteboardSortUpdate";}

@end
