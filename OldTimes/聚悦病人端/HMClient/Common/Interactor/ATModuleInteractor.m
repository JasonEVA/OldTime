//
//  ATModuleInteractor.m
//  ArthasBaseAppStructure
//
//  Created by Andrew Shen on 16/2/26.
//  Copyright © 2016年 Andrew Shen. All rights reserved.
//

#import "ATModuleInteractor.h"

@implementation ATModuleInteractor


+ (instancetype)sharedInstance {
    static ATModuleInteractor *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ATModuleInteractor alloc] init];
    });
    return sharedInstance;
}

/*
- (void)pushToVC:(UIViewController *)VC {
    [self.baseController.navigationController pushViewController:VC animated:YES];
//    UITabBarController *controller = (UITabBarController *)self.baseController.view.window.rootViewController;
//    UINavigationController *navi = controller.selectedViewController;
//    [navi pushViewController:VC animated:YES];
}

- (void)PushToChatVC:(UIViewController *)VC {
    UITabBarController *controller = (UITabBarController *)self.baseController.view.window.rootViewController;
    controller.selectedIndex = 2;
    UINavigationController *navi = controller.selectedViewController;
    [navi popToRootViewControllerAnimated:NO];
    [navi pushViewController:VC animated:YES];
}
*/
- (void)pushToVC:(UIViewController *)VC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UITabBarController *controller = (UITabBarController *)rootViewController;
    UINavigationController *navi = controller.selectedViewController;
    [VC setHidesBottomBarWhenPushed:YES];
    [navi pushViewController:VC animated:YES];
}

- (void)PushToChatVC:(UIViewController *)VC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UITabBarController *controller = (UITabBarController *)rootViewController;
    controller.selectedIndex = 2;
    UINavigationController *navi = controller.selectedViewController;
    [navi popToRootViewControllerAnimated:NO];
    [VC setHidesBottomBarWhenPushed:YES];
    
    [navi pushViewController:VC animated:YES];
}

- (void)popFirstVC:(UIViewController *)firstVC pushSecondVC:(UIViewController *)secondVC {
    UINavigationController *navi = firstVC.navigationController;
    [navi popToViewController:navi.viewControllers[navi.viewControllers.count - 2] animated:NO];
    [navi pushViewController:secondVC animated:NO];
}

- (void)popToTabBarSelectIndex:(NSInteger)index pushVC:(UIViewController *)pushVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UITabBarController *controller = (UITabBarController *)rootViewController;
    controller.selectedIndex = index;
    UINavigationController *navi = controller.selectedViewController;
    [navi popToRootViewControllerAnimated:NO];
    [pushVC setHidesBottomBarWhenPushed:YES];    
    [navi pushViewController:pushVC animated:NO];
    [navi.childViewControllers.firstObject setHidesBottomBarWhenPushed:NO];
}

@end
