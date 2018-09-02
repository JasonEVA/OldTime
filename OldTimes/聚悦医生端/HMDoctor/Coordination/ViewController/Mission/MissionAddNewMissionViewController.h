//
//  MissionAddNewMissionViewController.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
// 新建任务界面

#import "HMBaseViewController.h"
#import "MissionDetailModel.h"

@interface MissionAddNewMissionViewController : HMBaseViewController
@property (nonatomic, strong) UITableView *tableView;
//编辑任务入口
- (instancetype)initEditMissionWithModel:(MissionDetailModel *)model;
//新建任务入口
- (instancetype)initAddNewMission;
@end
