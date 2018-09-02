//
//  MeetingRoomListModel.m
//  launcher
//
//  Created by Andrew Shen on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingRoomListModel.h"
#import "NSDictionary+SafeManager.h"

#define MeetingList_SHOW_ID @"SHOW_ID"
#define MeetingList_R_NAME @"R_NAME"

@implementation MeetingRoomListModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.ID = [dict valueStringForKey:MeetingList_SHOW_ID];
            self.name = [dict valueStringForKey:MeetingList_R_NAME];
        }
    }
    return self;
}
@end
