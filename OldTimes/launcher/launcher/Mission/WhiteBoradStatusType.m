//
//  WhiteBoradStatusType.m
//  launcher
//
//  Created by William Zhang on 15/9/15.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "WhiteBoradStatusType.h"

@implementation WhiteBoradStatusType

+ (NSDictionary *)whiteBoardDict {
    return @{
             @"Wating":@(whiteBoardStyleWaiting),
             @"WATING":@(whiteBoardStyleWaiting),
             @"In_Progress":@(whiteBoardStyleInProgress),
             @"Finish":@(whiteBoardStyleFinish),
             @"FINISH":@(whiteBoardStyleFinish)
             };
}

+ (whiteBoardStyle)getWhiteBoardStyle:(NSString *)styleString {
    NSNumber *number = [[self whiteBoardDict] objectForKey:styleString];
    return [number integerValue];
}

+ (NSDictionary *)priorityDict {
    return @{
             @"LOW":@(MissionTaskPriorityLow),
             @"MEDIUM":@(MissionTaskPriorityMid),
             @"HIGH":@(MissionTaskPriorityHeigh),
             @"NONE":@(MissionTaskPriorityWithout)
             };
}

+ (MissionTaskPriority)getMissionPriority:(NSString *)priorityString {
    NSNumber *number = [[self priorityDict] objectForKey:priorityString];
    return [number integerValue];
}

+ (NSString *)getMissionPriorityString:(MissionTaskPriority)priority {
    NSArray *keys = [[self priorityDict] allKeysForObject:@(priority)];
    return [keys lastObject];
}

+ (NSString *)getMissionStatusString:(whiteBoardStyle)status {
    NSArray *keys = [[self whiteBoardDict] allKeysForObject:@(status)];
    return [keys lastObject];
}
@end
