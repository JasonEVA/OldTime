//
//  MeetingGetPeopleUnFreeListRequest.h
//  launcher
//
//  Created by William Zhang on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@interface MeetingGetPeopleUnFreeListResponse : BaseResponse

/** 存储（startTime）NSDate */
@property (nonatomic, strong) NSArray *arrayUnFreeList;

@end

@interface MeetingGetPeopleUnFreeListRequest : BaseRequest

/**
 *  获取非空闲时间
 *
 *  @param nameList  选择人员列表
 *  @param startTime 开始时间
 *  @param endTime   结束时间
 */
- (void)userNameList:(NSArray *)nameList startTime:(NSDate *)startTime endTime:(NSDate *)endTime;

@end
