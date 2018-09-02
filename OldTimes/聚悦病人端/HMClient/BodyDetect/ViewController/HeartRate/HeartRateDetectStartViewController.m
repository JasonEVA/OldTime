//
//  HeartRateDetectStartViewController.m
//  HMClient
//
//  Created by lkl on 2017/7/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HeartRateDetectStartViewController.h"

@interface HeartRateDetectStartViewController ()

@end

@implementation HeartRateDetectStartViewController

- (void)viewDidLoad {
    [self setAllowInputType:DetectInput_Manual];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"测心率"];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"历史记录" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnItemClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
}

- (NSString*) manualInputClassName
{
    return @"HeartRateManualInputViewController";
}

- (void)rightBtnItemClick
{
    UserInfo* targetUser = [[UserInfo alloc]init];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    [targetUser setUserId:curUser.userId];
    [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectRecordStartViewController" ControllerObject:targetUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
