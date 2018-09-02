//
//  UserLoginAccountTableViewController.m
//  HMDoctor
//
//  Created by yinquan on 17/3/2.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "UserLoginAccountTableViewController.h"
#import "AccountManageTableViewCell.h"
#import <MintcodeIMKit/MintcodeIMKit.h>

typedef NS_ENUM(NSUInteger, LoginAccountTableSection) {
    AccountListSection,
    AccountAppendSection,
    AccountListSectionCount,
};

@interface UserLoginAccountStartViewController ()
{
    UserLoginAccountTableViewController* accountTableViewController;
}
@end

@implementation UserLoginAccountStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"账号管理"];
    
    accountTableViewController = [[UserLoginAccountTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self addChildViewController:accountTableViewController];
    [self.view addSubview:accountTableViewController.tableView];
    
    [accountTableViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(14);
        make.bottom.equalTo(self.view);
    }];
    
}


@end

@interface UserLoginAccountTableViewController ()
{
    NSArray* accountList;
}
@end

@implementation UserLoginAccountTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationItem setTitle:@"切换账号"];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    LoginAccountUtil* util = [[LoginAccountUtil alloc] init];
    accountList = [util queryAccountList];
    
    UIView* headerLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    [headerLine setBackgroundColor:[UIColor commonControlBorderColor]];
    [self.tableView setTableHeaderView:headerLine];
    
    UIEdgeInsets edge = self.tableView.separatorInset;
    NSLog(@"edge %f", edge.left);
    edge.left = 0;
    [self.tableView setSeparatorInset:edge];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return AccountListSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    switch (section) {
        case AccountListSection:
        {
            if (accountList) {
                return accountList.count;
            }
            return 0;
            break;
            
        }
        case AccountAppendSection:
            return 1;
    }
    return 0;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    [footerview setBackgroundColor:[UIColor commonControlBorderColor]];
    return footerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    switch (indexPath.section)
    {
        case AccountListSection:
        {
            cell = [self accountCell:indexPath.row];
            break;
        }
        case AccountAppendSection:
        {
            cell = [self appendAccountCell];
            break;
        }
    }
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserLoginAccountTableViewCell"];
    }
    
    return cell;
}

- (UITableViewCell*) accountCell:(NSInteger) row
{
    AccountManageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AccountManageTableViewCell"];
    if (!cell)
    {
        cell = [[AccountManageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountManageTableViewCell"];
    }
    // Configure the cell...
    LoginAccountModel* model = accountList[row];
    [cell setLoginAccountModel:model];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell showAccountLogined:(model.login == 1)];
    
    return cell;
}

- (UITableViewCell*) appendAccountCell
{
    AccountManageAppendTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AccountManageAppendTableViewCell"];
    if (!cell)
    {
        cell = [[AccountManageAppendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountManageAppendTableViewCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case AccountAppendSection:
        {
            //登出系统，跳转到登录界面
            [[UserInfoHelper defaultHelper] userlogout];
            [[MessageManager share] logout];
            [[HMViewControllerManager defaultManager] startUserLogin];
        }
            break;
            
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    LoginAccountModel* model = accountList[indexPath.row];
    
    return (model.login == 0);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginAccountModel* model = accountList[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LoginAccountUtil* util = [[LoginAccountUtil alloc] init];
        [util deleteAccount:model.loginAccount];
        
        accountList = [util queryAccountList];
        [self.tableView reloadData];
    }
    
}
@end
