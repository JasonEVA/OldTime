//
//  BaseNavigationController.m
//  MintTeam
//
//  Created by William Zhang on 15/7/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate>

@end

@implementation BaseNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        self.navigationBar.barTintColor = [UIColor whiteColor];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                     NSFontAttributeName:[UIFont systemFontOfSize:18]}];
        self.navigationBar.tintColor = [UIColor themeBlue];

        self.navigationBar.translucent = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}


#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ( self.viewControllers.count <= 1)
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }else
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}




@end
