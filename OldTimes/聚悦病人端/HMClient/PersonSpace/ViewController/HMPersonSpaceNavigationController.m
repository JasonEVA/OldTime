//
//  HMPersonSpaceNavigationController.m
//  HMClient
//
//  Created by jasonwang on 2017/4/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMPersonSpaceNavigationController.h"
#import "UIBarButtonItem+BackExtension.h"
#import "UINavigationBar+JWGradient.h"
#import "HMPersonSpaceSecondEditionViewController.h"

@interface HMPersonSpaceNavigationController ()

@end

@implementation HMPersonSpaceNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{   //拦截所有push进来的子控制器
    
    // 拦截由HMPersonSpaceSecondEditionViewController push出来的VC，做隐藏操作
    if (self.viewControllers.count == 1 && [self.viewControllers.firstObject isKindOfClass:[HMPersonSpaceSecondEditionViewController class]]) {
        HMPersonSpaceSecondEditionViewController *VC = (HMPersonSpaceSecondEditionViewController *)self.viewControllers.firstObject;
        [VC hideMoveNameLbWhenPush];
    }
    
    if(self.viewControllers.count > 0)
    {
        
        [self.navigationBar jw_setBackgroundViewLayerWithAlpha:1];
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageNamed:@"back.png" targe:self action:@selector(backUp)];
    }
    [super pushViewController:viewController animated:animated];
    
}

//- (UIViewController *)popViewControllerAnimated:(BOOL)animated
//{
//    UIViewController* vcPop = [super popViewControllerAnimated:animated];
//    // 拦截pop到HMPersonSpaceSecondEditionViewController ，做显示操作
//
//    if (self.viewControllers.count == 1 && [self.viewControllers.firstObject isKindOfClass:[HMPersonSpaceSecondEditionViewController class]]) {
//        HMPersonSpaceSecondEditionViewController *VC = (HMPersonSpaceSecondEditionViewController *)self.viewControllers.firstObject;
//        [VC showMoveNameLbWhenPush];
//    }
//       return vcPop;
//}

- (void)backUp
{
    [self popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
