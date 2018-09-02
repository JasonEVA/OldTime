//
//  MissionAddMissionPatientTableView.h
//  HMDoctor
//
//  Created by jasonwang on 16/7/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//  新建任务病人高度自适应cell

#import <UIKit/UIKit.h>

@interface MissionAddMissionPatientTableView : UITableViewCell
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *contentLb;

+ (NSString *)identifier;

@end
