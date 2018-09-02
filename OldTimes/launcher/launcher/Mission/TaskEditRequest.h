//
//  TaskEditRequest.h
//  launcher
//
//  Created by William Zhang on 15/9/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  任务编辑request

#import "BaseRequest.h"

@class MissionDetailModel;

@interface TaskEditRequest : BaseRequest

- (void)editTaskModel:(MissionDetailModel *)detailModel editDitionary:(NSDictionary *)editDict;

@end
