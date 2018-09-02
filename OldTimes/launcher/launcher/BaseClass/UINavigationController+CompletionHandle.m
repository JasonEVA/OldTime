//
//  UINavigationController+CompletionHandle.m
//  launcher
//
//  Created by williamzhang on 15/11/20.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "UINavigationController+CompletionHandle.h"

@implementation UINavigationController (CompletionHandle)

- (void)wz_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    
    [self pushViewController:viewController animated:animated];
    
    [CATransaction commit];
}

- (void)wz_popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    
    [self popViewControllerAnimated:animated];
    
    [CATransaction commit];
}

- (void)wz_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    
    [self popToViewController:viewController animated:animated];
    
    [CATransaction commit];
}

- (void)wz_popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    
    [self popToRootViewControllerAnimated:animated];
    
    [CATransaction commit];
}

@end
