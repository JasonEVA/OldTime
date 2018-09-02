//
//  HMBaseNavigationViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/11.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMBaseNavigationViewController.h"
#import "UIBarButtonItem+BackExtension.h"

@interface HMBaseNavigationViewController ()
<UIGestureRecognizerDelegate>
@end

@implementation HMBaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationBar setBarTintColor:[UIColor mainThemeColor]];
    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    [self.navigationBar setTranslucent:NO];
    
    
//    self.interactivePopGestureRecognizer.delegate = self;

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
    NSArray* viewControllers = self.viewControllers;
    if (viewControllers.count > 1) {
        [self popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
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
