//
//  HMViewControllerManager.h
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainStartTabbarViewController.h"
#import "HMBasePageViewController.h"

@interface HMViewControllerManager : NSObject
{
    
}

@property (nonatomic, readonly) MainStartTabbarViewController* tvcRoot;

+ (HMViewControllerManager*) defaultManager;
+ (UIViewController*) topMostController;

+ (NSString*) controllerIdWithControllerName:(NSString*) controllerName
                            ControllerObject:(NSObject*) controllerObject;
+ (NSString*) controllerNameWithControllerId:(NSString*) controllerId;
+ (id) controllerObjectithControllerId:(NSString*) controllerId;

+ (HMBasePageViewController*) createViewControllerWithControllerName:(NSString*) controllerName
                                                          ControllerObject:(id) controllerObject;

+ (HMBasePageViewController*) createViewControllerWithControllerName:(NSString*) controllerName
                                                    FromControllerId:(NSString*) perControllerId
                                                    ControllerObject:(id) controllerObject;

- (void) entryMainPage;

- (void) entryUserLoginPage;

- (void) userLogout;

//用户登录界面
- (void) startUserLogin;
@end
