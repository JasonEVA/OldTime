//
//  HMBasePageViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMBasePageViewController.h"

@interface HMBasePageViewController ()<UIGestureRecognizerDelegate>
{
    UIView* navBarHairlineImageView;
}
@end

@implementation HMBasePageViewController

- (id) initWithControllerId:(NSString*) aControllerId
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        [self setControllerId:aControllerId];
        
        id object = [HMViewControllerManager controllerObjectithControllerId:aControllerId];
        if (object)
        {
            [self setParamObject:object];
        }
        
    }
    return self;
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //滑动返回
    __weak typeof(self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [self.navigationController interactivePopGestureRecognizer].delegate = weakSelf;
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    navBarHairlineImageView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSString *className = NSStringFromClass([self class]);
    ATLog(@"内存警告!!! VC = %@",className);
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
