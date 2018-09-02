//
//  PEFDetectStartViewController.m
//  HMClient
//
//  Created by lkl on 2017/6/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PEFDetectStartViewController.h"

@interface PEFDetectStartViewController ()

@end

@implementation PEFDetectStartViewController

- (void)viewDidLoad {
    [self setAllowInputType:DetectInput_Manual];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"测峰流速值"];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"历史记录" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnItemClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
}

- (NSString*) manualInputClassName
{
    return @"PEFManualInputViewController";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBtnItemClick
{
    UserInfo* targetUser = [[UserInfo alloc]init];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    [targetUser setUserId:curUser.userId];
    [HMViewControllerManager createViewControllerWithControllerName:@"PEFRecordsStartViewController" ControllerObject:targetUser];
}

@end
