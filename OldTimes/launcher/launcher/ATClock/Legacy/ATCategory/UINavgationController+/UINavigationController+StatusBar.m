//
//  UINavigationController+StatusBar.m
//  Clock
//
//  Created by Dariel on 16/7/29.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "UINavigationController+StatusBar.h"

@implementation UINavigationController (StatusBar)

- (UIViewController *)childViewControllerForStatusBarStyle {
    
    return self.topViewController;
}

@end
