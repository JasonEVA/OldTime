//
//  ApplyStyleKeyWordModel.m
//  launcher
//
//  Created by conanma on 15/11/5.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplyStyleKeyWordModel.h"

static NSString *const m_key = @"F_KEY";
static NSString *const m_name = @"F_NAME";
static NSString *const m_defaults = @"IS_DEFAULT";
static NSString *const m_sort = @"F_SORT";

@implementation ApplyStyleKeyWordModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (dict)
    {
        if ([dict objectForKey:m_key])
        {
            self.key = [dict objectForKey:m_key];
        }
        if ([dict objectForKey:m_key])
        {
            self.name = [dict objectForKey:m_name];
        }
        if ([dict objectForKey:m_defaults])
        {
            self.def = [[dict objectForKey:m_defaults] integerValue];
        }
        if ([dict objectForKey:m_sort])
        {
            self.sort = [[dict objectForKey:m_sort] integerValue];
        }
    }
    return self;
}
@end
