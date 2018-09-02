//
//  PersonInfoViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "PersonInfoTableViewController.h"

@interface PersonInfoViewController ()
{
    PersonInfoTableViewController *tvcPersonInfo;
}
@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"个人资料"];
    
    [self initContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) initContentView
{
    tvcPersonInfo = [[PersonInfoTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcPersonInfo];
    [tvcPersonInfo.tableView setFrame:self.view.bounds];
    [self.view addSubview:tvcPersonInfo.tableView];
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
