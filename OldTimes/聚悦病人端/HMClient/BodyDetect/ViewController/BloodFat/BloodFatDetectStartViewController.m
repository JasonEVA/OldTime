//
//  BloodFatDetectStartViewController.m
//  HMClient
//
//  Created by lkl on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodFatDetectStartViewController.h"

@interface BloodFatDetectStartViewController ()

@end

@implementation BloodFatDetectStartViewController

- (void)viewDidLoad {
    [self setAllowInputType:DetectInput_Device|DetectInput_Manual];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"血脂"];
    
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
    return @"BloodFatDetectViewController";
}

- (NSString*) manualInputClassName
{
    return @"BloodFatManualInputViewController";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) entryRecordHistoryViewController:(id) sender
{
    UserInfo* targetUser = [[UserInfo alloc]init];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    [targetUser setUserId:curUser.userId];
    [HMViewControllerManager createViewControllerWithControllerName:@"BloodFatDetectRecordsStartViewController" ControllerObject:targetUser];
}

@end
