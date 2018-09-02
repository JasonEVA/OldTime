//
//  TaskCountModel.m
//  launcher
//
//  Created by TabLiu on 16/2/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "TaskCountModel.h"
#import "NSDictionary+SafeManager.h"

@implementation TaskCountModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _type = [[dic valueStringForKey:@"type"] intValue];
        _count = [[dic valueStringForKey:@"count"] intValue];
    }
    return self;
}

@end