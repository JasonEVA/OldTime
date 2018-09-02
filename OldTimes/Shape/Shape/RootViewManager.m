//
//  RootViewManager.m
//  PalmDoctorPT
//
//  Created by Andrew Shen on 15/4/3.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#import "RootViewManager.h"
#import "LoginViewController.h"
#import "unifiedUserInfoManager.h"
#import "BaseNavigationViewController.h"
#import "MyDefine.h"

@interface RootViewManager ()

@property (nonatomic, strong)  HomeTabBarViewController  *homeVC; // 主页
@property (nonatomic, strong)  LoginViewController  *loginVC; // <##>
@end
@implementation RootViewManager

#pragma mark - Interface Method
+ (RootViewManager *)share
{
    static RootViewManager *rootManager = nil;
    static dispatch_once_t singleRootManager;
    dispatch_once(&singleRootManager, ^{
        rootManager = [[self alloc] init];
    });
    return rootManager;
}

- (id)init
{
    if (self = [super init])
    {
        // 增加消息监听
        [self addNotification];
    }
    return self;
}


// 登录方式
- (void)loginQueue
{
    
    [self updateRootViewController:self.homeVC];
    
    if (![[unifiedUserInfoManager share] loginStatus]) {
        [self performSelector:@selector(showLogin) withObject:nil afterDelay:0];
    }
    
}
#pragma mark - Private Method

// 修改rootViewController
- (void)updateRootViewController:(UIViewController *)viewController
{
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:viewController];
}


// 显示登录页
- (void)showLogin {
    [self.homeVC presentViewController:self.loginVC animated:YES completion:nil];

}

// 显示home页，清除登录页
- (void)showHome {
    [self.homeVC dismissViewControllerAnimated:YES completion:^{
        _loginVC = nil;
    }];
}

// 重新登录
- (void)reLogin
{
//     销毁主页
    if (_homeVC)
    {
        
        [_homeVC removeFromParentViewController];
        [_homeVC.view removeFromSuperview];
        _homeVC = nil;
    }
    
    [self loginQueue];
}

// 退出登录
- (void)userLogOut
{
    // 清除数据
    [self cleanDataForReLogin];
    // 清除页面
    // 跳到登录页
    [self reLogin];
}

// 重新登录需要释放单例，清除数据
- (void)cleanDataForReLogin
{
    // 清理用户登录数据
    [[unifiedUserInfoManager share] removeUserInfo];
}

// 注册通知
- (void)addNotification
{
    // 通知
    
    // 显示登录页
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLogin) name:n_showLogin object:nil];

    // 显示主页
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHome) name:n_showHome object:nil];
    
    // 重新登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogOut) name:n_logout object:nil];

    // 退出登录，只为用户注销服务
}

#pragma mark - init
- (HomeTabBarViewController *)homeVC {
    if (!_homeVC) {
        _homeVC = [[HomeTabBarViewController alloc] init];
    }
    return _homeVC;
}

- (LoginViewController *)loginVC {
    if (!_loginVC) {
        _loginVC = [[LoginViewController alloc] init];
    }
    return _loginVC;
}

@end
