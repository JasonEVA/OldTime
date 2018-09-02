//
//  InitializeViewController.m
//  HMClient
//
//  Created by yinquan on 16/12/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "InitializeViewController.h"
#import "InitializationHelper.h"

@interface InitializeViewController ()
<InitializeHelperDelegate>

@end

@implementation InitializeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    UIImageView* ivWelcome = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"launch_BG"]];
    [self.view addSubview:ivWelcome];
    [ivWelcome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    
    UIImageView* ivLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launch_logo"]];
    [self.view addSubview:ivLogo];
    [ivLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(ivWelcome.mas_bottom).with.offset(25);
//        make.size.mas_equalTo(CGSizeMake(160, 48));
        
    }];
    
    
    
    UIImageView* ivLogoName = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launch_logoName"]];
    [self.view addSubview:ivLogoName];
    
    [ivLogoName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-40);
    }];
    
    InitializationHelper* initHelper = [InitializationHelper defaultHelper];
    [initHelper setDelegate:self];
    [initHelper startInitialize];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) backToMain
{
    [[HMViewControllerManager defaultManager] entryMainPage];
}

- (void) checkNetworkStatus
{
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void) initializeError:(NSInteger) errorCode
                 Message:(NSString*) errMsg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:errMsg preferredStyle:UIAlertControllerStyleAlert];
    //添加确定
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        exit(0);
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
