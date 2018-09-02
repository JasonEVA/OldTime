//
//  InitializeViewController.m
//  HMDoctor
//
//  Created by yinquan on 16/4/11.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "InitializeViewController.h"

@interface InitializeViewController ()
<InitializeHelperDelegate>
{
    //UIImageView* ivWelcome;
}
@end

@implementation InitializeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    //[self performSelector:@selector(backToMain) withObject:nil afterDelay:2.4];
    
    UIImageView* ivWelcome = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_background"]];
    [self.view addSubview:ivWelcome];
    [ivWelcome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    UIImageView* ivLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_juyue"]];
    [self.view addSubview:ivLogo];
    [ivLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(91);
        make.size.mas_equalTo(CGSizeMake(160, 48));
        
    }];
    
    UILabel* copyRightLabel = [[UILabel alloc] init];
    [self.view addSubview:copyRightLabel];
    [copyRightLabel setText:@"重庆聚悦健康管理有限公司  Copyright © 2016年 ."];
    [copyRightLabel setFont:[UIFont systemFontOfSize:13]];
    [copyRightLabel setTextColor:[UIColor whiteColor]];
    
    [copyRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-20);
    }];
    
    InitializeHelper* initHelper = [InitializeHelper defaultHelper];
    [initHelper setDelegate:self];
    //[initHelper startInitialize];
    
    //[self backToMain];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    InitializeHelper* initHelper = [InitializeHelper defaultHelper];
//    [initHelper setDelegate:self];
    [initHelper startInitialize];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) backToMain
{
//    [InitializeHelper defaultHelper].initialized = YES;
    [[HMViewControllerManager defaultManager] entryMainStart];
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
