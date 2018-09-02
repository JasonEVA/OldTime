//
//  NewMissionContainViewController.h
//  launcher
//
//  Created by williamzhang on 16/3/3.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  新版本任务容器controller

#import <MMDrawerController/MMDrawerController.h>

@interface NewMissionContainViewController : MMDrawerController

- (instancetype)init NS_DESIGNATED_INITIALIZER;

/// 被viewController present
- (void)presentedByViewController:(UIViewController *)viewController;

- (void)selectAtIndex:(NSInteger)index;

@end
