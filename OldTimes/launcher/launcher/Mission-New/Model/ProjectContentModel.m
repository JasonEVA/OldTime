//
//  ProjectContentModel.m
//  launcher
//
//  Created by TabLiu on 16/2/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ProjectContentModel.h"
#import "NSDictionary+SafeManager.h"

@implementation ProjectContentModel

- (id)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _showId = [dic valueStringForKey:@"showId"];
        _name = [dic valueStringForKey:@"name"];
        _teamNumber = [[dic valueStringForKey:@"teamNumber"] longLongValue];
        _unFinishedTask = [[dic valueStringForKey:@"unFinishedTask"] integerValue];
        _allTask = [[dic valueStringForKey:@"allTask"] integerValue];
        _createUser = [dic valueStringForKey:@"createUser"];
    }
    return self;
}

@end
