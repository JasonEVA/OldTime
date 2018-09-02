//
//  BodyPressureDetectStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyPressureDetectStartViewController.h"

@interface BodyPressureDetectStartViewController ()

@end

@implementation BodyPressureDetectStartViewController

- (void)viewDidLoad {
    [self setAllowInputType:(DetectInput_Device|DetectInput_Manual)];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"血压"];
    
    NSString* btiTitle = @"历史记录";
    CGFloat titleWidth = [btiTitle widthSystemFont:[UIFont font_30]];
    UIButton* historybutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, titleWidth, 25)];
    [historybutton setTitle:@"历史记录" forState:UIControlStateNormal];
    [historybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [historybutton.titleLabel setFont:[UIFont font_30]];
    [historybutton addTarget:self action:@selector(entryRecordHistoryViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* bbiHistory = [[UIBarButtonItem alloc]initWithCustomView:historybutton];
    [self.navigationItem setRightBarButtonItem:bbiHistory];
}

- (NSString*) deviceInputClassName
{
    return @"BloodPressureDetectViewController";
}

- (NSString*) manualInputClassName
{
    return @"BloodPressureManualInputViewController";
}

- (void) entryRecordHistoryViewController:(id) sender
{
    UserInfo* targetUser = [[UserInfo alloc]init];

    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    [targetUser setUserId:curUser.userId];
    [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureRecordStartViewController" ControllerObject:targetUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end



