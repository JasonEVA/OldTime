//
//  UIViewController+modalPresent.m
//  launcher
//
//  Created by williamzhang on 15/12/29.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "UIViewController+modalPresent.h"

@implementation UIViewController (modalPresent)

- (void)modalPresentViewController:(UIViewController *)viewControllerToPresent {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.providesPresentationContextTransitionStyle = YES;
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
    } else {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}

@end
