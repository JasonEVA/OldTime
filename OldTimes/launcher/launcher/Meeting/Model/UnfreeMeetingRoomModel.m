//
//  UnfreeMeetingRoomModel.m
//  launcher
//
//  Created by Andrew Shen on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "UnfreeMeetingRoomModel.h"
#import "NSDictionary+SafeManager.h"

#define UNFREEROOM @"MeetingRoomNo"
@implementation UnfreeMeetingRoomModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.MeetingRoomNo = [dict valueStringForKey:UNFREEROOM];
        }
    }
    return self;
}
@end
