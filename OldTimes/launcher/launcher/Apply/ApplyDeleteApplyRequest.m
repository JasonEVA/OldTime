//
//  ApplyDeleteApplyRequest.m
//  launcher
//
//  Created by Dee on 15/9/6.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyDeleteApplyRequest.h"

static NSString *const A_ShowId = @"SHOW_ID";

@implementation ApplyDeleteApplyRequest

- (NSString *)api
{
 return @"/Approve-Module/Approve";
}

- (NSString *)type
{
    return @"DELETE";
}

- (void)deleteApplyWithShowID:(NSString *)showId
{
    self.params[A_ShowId] = showId;
    [self requestData];
}

@end
