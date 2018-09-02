//
//  NewUserDetailViewController.h
//  launcher
//
//  Created by TabLiu on 16/3/25.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  user详情页面

#import "BaseViewController.h"

@class MessageRelationInfoModel;

@interface NewUserDetailViewController : BaseViewController

/** 初始化用户 */
- (instancetype)initWithUserModel:(MessageRelationInfoModel *)model;
 
@end
