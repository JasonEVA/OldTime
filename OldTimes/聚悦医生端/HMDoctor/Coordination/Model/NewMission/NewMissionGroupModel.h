//
//  NewMissionGroupModel.h
//  HMDoctor
//
//  Created by jasonwang on 16/8/4.
//  Copyright © 2016年 yinquan. All rights reserved.
//  第二版任务中的服务组model

#import <Foundation/Foundation.h>

@interface NewMissionGroupModel : NSObject
@property (nonatomic, copy) NSString *teamId;
@property (nonatomic, copy) NSString *teamName;
@property (nonatomic) NSInteger doneCount;
@property (nonatomic) NSInteger allCount;

@end
