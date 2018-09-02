//
//  MissionListModel.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//  任务列表model

#import <Foundation/Foundation.h>

@class MissionDetailModel;

@interface MissionListModel : NSObject

@property (nonatomic, copy)  NSArray<MissionDetailModel *>  *history; // 已过期
@property (nonatomic, copy)  NSArray<MissionDetailModel *>  *records; // 未过期，或仅仅只是消息记录

@end
