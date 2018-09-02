//
//  FriendsStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "FriendsStartViewController.h"
#import "FriendsTableViewController.h"
#import "HMSwitchView.h"

@interface FriendsStartViewController ()
<HMSwitchViewDelegate>
{
    HMSwitchView* switchview;
    FriendsTableViewController* tvcFriends;
}
@end

@implementation FriendsStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"我的亲友"];
    
    UIButton* appendBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [appendBtn setImage:[UIImage imageNamed:@"btn_home_add"] forState:UIControlStateNormal];
    [appendBtn addTarget:self action:@selector(appendBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* appendBBI = [[UIBarButtonItem alloc]initWithCustomView:appendBtn];
    [self.navigationItem setRightBarButtonItem:appendBBI];
    
    [self createSwtichView];
    
    tvcFriends = [[FriendsTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcFriends];
    [self.view addSubview:tvcFriends.tableView];
    
    [tvcFriends.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(switchview.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createSwtichView
{
    switchview = [[HMSwitchView alloc]init];
    [self.view addSubview:switchview];
    [switchview createCells:@[@"我关注的", @"关注我的"]];
    [switchview setDelegate:self];
    [switchview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
}

- (void) appendBarButtonClicked:(id) sender
{
    //AppendFriendViewController
    [HMViewControllerManager createViewControllerWithControllerName:@"AppendFriendViewController" ControllerObject:nil];
}

#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView *)switchview SelectedIndex:(NSInteger)selectedIndex
{
    if (tvcFriends)
    {
        [tvcFriends setRelativeType:selectedIndex];
    }
}
@end
