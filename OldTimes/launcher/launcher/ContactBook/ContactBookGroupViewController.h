//
//  ContactBookGroupViewController.h
//  launcher
//
//  Created by williamzhang on 16/2/25.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  我的群组界面

#import "BaseViewController.h"

@class SelectContactTabbarView;

@interface ContactBookGroupViewController : BaseViewController

/// 是否为选人模式
- (instancetype)initWithTabbar:(SelectContactTabbarView *)tabbar;

@end
