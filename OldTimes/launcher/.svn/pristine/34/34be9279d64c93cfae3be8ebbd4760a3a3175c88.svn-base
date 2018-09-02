//
//  ApplyChangeCommentWordRequest.m
//  launcher
//
//  Created by conanma on 15/10/16.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplyChangeCommentWordRequest.h"

static NSString *const showid = @"SHOW_ID";
static NSString *const HAS_COMMENT = @"HAS_COMMENT";

@implementation ApplyChangeCommentWordRequest

- (void)GetShowID:(NSString *)ShowID
{
    self.params[HAS_COMMENT] = @1;
    self.params[showid] = ShowID;
    [self requestData];
}

- (NSString *)api {
    return @"/Approve-Module/Approve/PostComment";
}

- (NSString *)type {
    return @"POST";
}

@end