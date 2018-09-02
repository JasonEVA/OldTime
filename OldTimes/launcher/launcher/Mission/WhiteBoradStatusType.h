//
//  WhiteBoradStatusType.h
//  launcher
//
//  Created by William Zhang on 15/9/15.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  白板状态分类

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, whiteBoardStyle) {
    whiteBoardStyleWaiting = 0,
    whiteBoardStyleInProgress,
    whiteBoardStyleFinish,
};

typedef NS_ENUM(NSUInteger, MissionTaskPriority) {
    MissionTaskPriorityLow = 0,
    MissionTaskPriorityMid,
    MissionTaskPriorityHeigh,
    MissionTaskPriorityWithout,
};

@interface WhiteBoradStatusType : NSObject

+ (whiteBoardStyle)getWhiteBoardStyle:(NSString *)styleString;
+ (MissionTaskPriority)getMissionPriority:(NSString *)priorityString;
+ (NSString *)getMissionPriorityString:(MissionTaskPriority)priority;
+ (NSString *)getMissionStatusString:(whiteBoardStyle)status;
@end
