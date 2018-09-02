//
//  RootViewControllerManager.h
//  launcher
//
//  Created by William Zhang on 15/7/24.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  管理RootVC单例

#import <UIKit/UIKit.h>

@class CompanyModel;

@interface RootViewControllerManager : NSObject

- (instancetype)initWithWindow:(UIWindow *)window;

- (void)loginWays;

- (void)showPasswordLogin;
- (void)showPasswordLoginViewForValid; //身份过期，重新登陆
- (void)showGraphicSetting;
- (void)showCompany;
- (void)showHome;
- (void)showGraphicLogin;

- (void)dissGestureVerify;
- (void)releaseHomeView;

/** 在我的界面中处理后销毁tabbar然后进入到我的界面 */
- (void)changeStatus;

// 3DTouch跳转
/// 新建聊天
- (void)beginChat;

/// 扫一扫
- (void)beginQRCode;

/// 搜索
- (void)beginSearch;

/// 新建日程
- (void)beginNewCalendar;

/** 登录状态下需要存储列表，选完之后将清空 */
@property (nonatomic, strong) NSArray <CompanyModel *> *companyList;

@end
