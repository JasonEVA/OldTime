//
//  HMViewControllerManager.h
//  HMDoctor
//
//  Created by yinquan on 16/4/9.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMBaseViewController.h"
#import "HMBasePageViewController.h"
#import "HMBaseNavigationViewController.h"

@interface HMViewControllerManager : NSObject
{
    
}

@property (nonatomic, readonly) UINavigationController* navRoot;
@property (nonatomic, readonly) UITabBarController* tabRoot;

+ (HMViewControllerManager*) defaultManager;

+ (UIViewController*) topMostController;

+ (NSString*) controllerIdWithControllerName:(NSString*) controllerName
                            ControllerObject:(NSObject*) controllerObject;
+ (NSString*) controllerNameWithControllerId:(NSString*) controllerId;
+ (id) controllerObjectithControllerId:(NSString*) controllerId;

+ (HMBasePageViewController*) entryPageViewController:(HMBasePageViewController*) pageViewController;

+ (HMBasePageViewController*) createViewControllerWithControllerName:(NSString*) controllerName
                                                    ControllerObject:(id) controllerObject;

+ (HMBasePageViewController*) createViewControllerWithControllerName:(NSString*) controllerName
                                                    FromControllerId:(NSString*) perControllerId
                                                    ControllerObject:(id) controllerObject;
- (void) entryMainStart;

//返回App首页
- (void) popToHomePage;

//用户登录界面
- (void) startUserLogin;

// 用户退出登录
- (void) userLogout;
@end
