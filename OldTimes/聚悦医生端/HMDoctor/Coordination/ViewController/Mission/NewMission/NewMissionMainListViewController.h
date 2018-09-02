//
//  NewMissionMainListViewController.h
//  HMDoctor
//
//  Created by jasonwang on 16/8/3.
//  Copyright © 2016年 yinquan. All rights reserved.
//  第二版任务列表界面

#import "HMBaseViewController.h"
@class TaskTypeTitleAndCountModel;
@class NewMissionGroupModel;

@interface NewMissionMainListViewController : HMBaseViewController
//通过服务群获取任务列表
- (instancetype)initWithTeamModel:(NewMissionGroupModel *)model;
//通过任务类型获取任务列表
- (instancetype)initWithTypeModel:(TaskTypeTitleAndCountModel *)model;
@end
