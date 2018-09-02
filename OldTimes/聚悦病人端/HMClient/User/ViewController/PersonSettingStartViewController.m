//
//  PersonSettingStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonSettingStartViewController.h"
#import "PersonSettingTableViewController.h"

@interface PersonSettingStartViewController ()
{
    PersonSettingTableViewController *tvcPersonSetting;
}
@end

@implementation PersonSettingStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"设置"];
    //[self.navigationController setNavigationBarHidden:NO];
    [self initContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void) initContentView
{
    tvcPersonSetting = [[PersonSettingTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcPersonSetting];
    [tvcPersonSetting.tableView setFrame:self.view.bounds];
    [self.view addSubview:tvcPersonSetting.tableView];
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
