//
//  ContactBookViewController.h
//  launcher
//
//  Created by kylehe on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  新版通讯录界面

#import "ContactBookSearchViewController.h"

@interface ContactBookViewController : ContactBookSearchViewController

/// 有tabbar为选择模式
- (instancetype)initWithTabbar:(SelectContactTabbarView *)tabbar;

@end
