//
//  NSDictionary+ATEX.m
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "NSDictionary+ATEX.h"

@implementation NSDictionary (ATEX)

- (id)safeValueForKey:(NSString *)key{
    id value = [self valueForKey:key];
    if([value isKindOfClass:[NSNull class]]){
        value = nil;
    }
    return value;
}

@end
