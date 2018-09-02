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
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(p_realPushToVC:) withObject:VC afterDelay:0.01];
}

- (void)PushToChatVC:(UIViewController *)VC {
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(p_realPushToChatVC:) withObject:VC afterDelay:0.01];
}

#pragma mark - Private
- (void)p_realPushToVC:(UIViewController *)VC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UITabBarController *controller = (UITabBarController *)rootViewController;
    UINavigationController *navi = controller.selectedViewController;
    [VC setHidesBottomBarWhenPushed:YES];
    [navi pushViewController:VC animated:YES];
}

- (void)p_realPushToChatVC:(UIViewController *)VC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UITabBarController *controller = (UITabBarController *)rootViewController;
    controller.selectedIndex = 2;
    UINavigationController *navi = controller.selectedViewController;
    [navi popToRootViewControllerAnimated:NO];
    [VC setHidesBottomBarWhenPushed:YES];
    
    [navi pushViewController:VC animated:YES];
}



@end
