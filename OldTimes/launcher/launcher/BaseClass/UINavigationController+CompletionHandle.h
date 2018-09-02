//
//  UINavigationController+CompletionHandle.h
//  launcher
//
//  Created by williamzhang on 15/11/20.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (CompletionHandle)

- (void)wz_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

- (void)wz_popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)wz_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)wz_popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
