//
//  UnfreeMeetingRoomModel.h
//  launcher
//
//  Created by Andrew Shen on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
// 非空闲会议室列表

#import <Foundation/Foundation.h>

@interface UnfreeMeetingRoomModel : NSObject

@property (nonatomic, copy)  NSString  *MeetingRoomNo; // 非空闲ID

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
