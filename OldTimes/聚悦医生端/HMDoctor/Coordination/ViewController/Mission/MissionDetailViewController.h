//
//  MissionDetailViewController.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/18.
//  Copyright © 2016年 yinquan. All rights reserved.
//  任务详情VC

#import "HMBaseViewController.h"
#import "MissionDetailModel.h"

@interface MissionDetailViewController : HMBaseViewController

- (instancetype)initWithMissionModel:(MissionDetailModel *)model;
//从卡片中点击进入
- (instancetype)initWIthMissionID:(MissionDetailModel *)model;


@end
