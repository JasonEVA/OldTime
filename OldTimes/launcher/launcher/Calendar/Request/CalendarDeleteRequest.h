//
//  CalendarDeleteRequest.h
//  launcher
//
//  Created by Kyle He on 15/8/20.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  删除日程类

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@interface CalendarDeleteResponse : BaseResponse
@property (nonatomic) NSInteger isNeedEdit;
@end


@interface CalendarDeleteRequest : BaseRequest

- (void)deleteSheduleByShowId:(NSString *)showId initialStartTime:(NSDate *)initialStartTime saveType:(NSInteger)savetype;
- (void)deleteSheduleByRelateId:(NSString *)relateId initialStartTime:(NSDate *)initialStartTime saveType:(NSInteger)savetype;

@end
