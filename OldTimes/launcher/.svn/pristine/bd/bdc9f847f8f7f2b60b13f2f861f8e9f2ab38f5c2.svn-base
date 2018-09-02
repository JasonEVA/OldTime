//
//  MeetingJoinPersonModel.m
//  launcher
//
//  Created by Andrew Shen on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingJoinPersonModel.h"
#import "NSDictionary+SafeManager.h"

static NSString * const d_name   = @"NAME";
static NSString * const d_isJoin = @"ISJOIN";

@implementation MeetingJoinPersonModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.NANE = [dict valueStringForKey:d_name];
            self.ISJOIN = [[dict valueNumberForKey:d_isJoin] integerValue];
        }
    }
    return self;
}
@end
