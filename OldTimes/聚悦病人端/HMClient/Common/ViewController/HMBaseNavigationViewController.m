//
//  HMBaseNavigationViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/11.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMBaseNavigationViewController.h"
#import "UIBarButtonItem+BackExtension.h"
#import "UINavigationBar+JWGradient.h"

@interface HMBaseNavigationViewController ()

@end

@implementation HMBaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationBar setShadowImage:[UIImage new]];

    [self.navigationBar jw_setBackgroundViewLayerWithAlpha:1];

    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont boldFont_36]}];
    [self.navigationBar setTranslucent:NO];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{   //拦截所有push进来的子控制器
    if(self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageNamed:@"back.png" targe:self action:@selector(backUp)];
        
    }
    [super pushViewController:viewController animated:animated];
    
}

- (void)backUp
{
    [self popViewControllerAnimated:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController* vcPop = [super popViewControllerAnimated:animated];
    NSArray* controllers = self.viewControllers;
    if (1 == controllers.count)
    {
        MainStartTabbarViewController* tvcRoot = [[HMViewControllerManager defaultManager] tvcRoot];
        [tvcRoot queryUnReadMessage];
    }
    return vcPop;
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
