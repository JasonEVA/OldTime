//
//  HMBaseViewController.m
//  HMDoctor
//
//  Created by yinquan on 16/4/9.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMBaseViewController.h"

@interface HMBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation HMBaseViewController

- (void)dealloc {
    NSLog(@"-------------->dealloc:%@",self.description);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor commonBackgroundColor];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    NSString *className = NSStringFromClass([self class]);
    
    ATLog(@"内存警告!!! VC = %@",className);
    // Dispose of any resources that can be recreated.
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
