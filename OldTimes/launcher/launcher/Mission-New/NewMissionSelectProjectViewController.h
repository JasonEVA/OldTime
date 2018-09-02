//
//  NewMissionSelectProjectViewController.h
//  launcher
//
//  Created by jasonwang on 16/2/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  选择项目界面

#import "BaseViewController.h"

@class ProjectModel;

typedef void(^NewMissionSelectProjectBlock)(ProjectModel *project);
typedef void(^NewMissionSelectProjectDismissBlock)();

@interface NewMissionSelectProjectViewController : BaseViewController

- (instancetype)initWithSelectProject:(NewMissionSelectProjectBlock)selectBlock;
@property (nonatomic, copy) NSString *selectedProjectShowID;
@end
