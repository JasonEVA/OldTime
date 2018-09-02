//
//  CalendarNewMakeSureRequest.m
//  launcher
//
//  Created by William Zhang on 15/8/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarNewMakeSureRequest.h"

static NSString *const d_showId = @"showId";

@implementation CalendarNewMakeSureRequest

- (void)sureWithShowId:(NSString *)showId {
    self.params[d_showId] = showId;
    [self requestData];
}

- (NSString *)api {
    return @"/Schedule-Module/Schedule/Sure";
}

@end
