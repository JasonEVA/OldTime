//
//  MissionSelectProjectViewController.h
//  launcher
//
//  Created by William Zhang on 15/9/9.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  选择项目界面

#import "BaseViewController.h"

@class ProjectModel;

typedef void(^MissionSelectProjectBlock)(ProjectModel *project);
typedef void(^MissionSelectProjectDismissBlock)();

@interface MissionSelectProjectViewController : BaseViewController

- (instancetype)initWithSelectProject:(MissionSelectProjectBlock)selectBlock;

@end
