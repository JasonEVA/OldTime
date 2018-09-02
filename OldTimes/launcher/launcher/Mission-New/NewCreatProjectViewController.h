//
//  NewCreatProjectViewController.h
//  launcher
//
//  Created by TabLiu on 16/2/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
// 新建项目

#import "BaseViewController.h"

@class ProjectContentModel;

@interface NewCreatProjectViewController : BaseViewController

- (instancetype)initWithProjectModel:(ProjectContentModel *)project completion:(void (^)())completion;
- (instancetype)initWithCompletion:(void (^)(ProjectContentModel *project))completion;

@end
