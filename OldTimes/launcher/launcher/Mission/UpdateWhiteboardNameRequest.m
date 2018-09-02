//
//  UpdateWhiteboardNameRequest.m
//  launcher
//
//  Created by williamzhang on 15/11/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "UpdateWhiteboardNameRequest.h"

static NSString * const d_showId = @"showId";
static NSString * const d_name   = @"name";

@implementation UpdateWhiteboardNameRequest

- (void)updateName:(NSString *)name showId:(NSString *)showId {
    _updatedName = name;
    self.params[d_showId] = showId;
    self.params[d_name]   = name;
    [self requestData];
}

- (NSString *)api { return @"/Task-Module/Task/WhiteboardNameUpdate";}

@end
