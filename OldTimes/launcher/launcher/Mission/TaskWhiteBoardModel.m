//
//  TaskWhiteBoardModel.m
//  launcher
//
//  Created by William Zhang on 15/9/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "TaskWhiteBoardModel.h"
#import "NSDictionary+SafeManager.h"

static NSString * const r_showId = @"showId";
static NSString * const r_name   = @"name";
static NSString * const r_type   = @"type";
static NSString * const r_sort   = @"sort";

@implementation TaskWhiteBoardModel

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.showId = [dict valueStringForKey:r_showId];
        self.title = [dict valueStringForKey:r_name];
        
        NSString *styleString = [dict valueStringForKey:r_type];
        self.style = [WhiteBoradStatusType getWhiteBoardStyle:styleString];
        
        self.sort = [[dict valueNumberForKey:r_sort] integerValue];
    }
    return self;
}

@end
