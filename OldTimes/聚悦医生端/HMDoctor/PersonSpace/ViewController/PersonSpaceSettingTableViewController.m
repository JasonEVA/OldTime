//
//  PersonSpaceSettingTableViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/4/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PersonSpaceSettingTableViewController.h"
//#import "PersonSpaceSettingViewController.h"
#import "PersonSpaceSettingTableViewCell.h"
#import <MintcodeIMKit/MintcodeIMKit.h>

@interface PersonSpaceSettingViewController ()
{
    PersonSpaceSettingTableViewController* tvcSetting;
}
@end

@implementation PersonSpaceSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"设置"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(!tvcSetting)
    {
        tvcSetting = [[PersonSpaceSettingTableViewController alloc]initWithStyle:UITableViewStylePlain];
        [self addChildViewController:tvcSetting];
        [tvcSetting.tableView setFrame:self.view.bounds];
        [self.view addSubview:tvcSetting.tableView];
    }

}
//- (void) viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    if(!tvcSetting)
//    {
//        tvcSetting = [[PersonSpaceSettingTableViewController alloc]initWithStyle:UITableViewStylePlain];
//        [self addChildViewController:tvcSetting];
//        [tvcSetting.tableView setFrame:self.view.bounds];
//        [self.view addSubview:tvcSetting.tableView];
//    }
//    
//}

@end


typedef enum : NSUInteger {
    PersonSettingManagereSction,
    PersonSettingNotificationSection,
    PersonSettingLogoutSection,
    PersonSettingSectionCount,
} PersonSettingSection;

typedef enum : NSUInteger {
    PersonManagerFeedbackIndex,
    PersonManagerPasswordIndex,
    PersonManagerAboutUsIndex,
    PersonManagerAccountIndex,  //账号管理
    PersonManagerIndexCount,
} PersonManagerIndex;

@interface PersonSpaceSettingTableViewController ()

@end

@implementation PersonSpaceSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return PersonSettingSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    switch (section)
    {
        case PersonSettingManagereSction:
        {
            return PersonManagerIndexCount;
        }
            break;
        case PersonSettingNotificationSection:
        case PersonSettingLogoutSection:
        {
            return 1;
        }
        default:
            break;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 14;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 14)];
    [headerview setBackgroundColor:[UIColor commonBackgroundColor]];
    [headerview showBottomLine];
    return headerview;
}

- (CGFloat) footerviewHeight:(NSInteger) section
{
    switch (section)
    {
        case PersonSettingNotificationSection:
            return 27;
            break;
            
        default:
            break;
    }
    return 0.5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self footerviewHeight:section];
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, [self footerviewHeight:section])];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    switch (section)
    {
        case PersonSettingNotificationSection:
        {
            UILabel* lbNotice = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 290, 17)];
            [lbNotice setBackgroundColor:[UIColor clearColor]];
            [lbNotice setText:@"您可以在手机设置>通知中心里进行设置"];
            [lbNotice setTextColor:[UIColor commonLightGrayTextColor]];
            [lbNotice setFont:[UIFont systemFontOfSize:10]];
            [footerview addSubview:lbNotice];
        }
            break;
            
        default:
            break;
    }
    [footerview showBottomLine];
    return footerview;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case PersonSettingManagereSction:
        {
            cell = [self personSettingManagerCell:indexPath.row];
        }
            break;
        case PersonSettingNotificationSection:
        {
            cell = [self personSettingNotificationCell];
        }
            break;
        case PersonSettingLogoutSection:
        {
            cell = [self personSettingLogoutCell];
        }
            break;
        default:
            break;
    }
    // Configure the cell...
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonSpaceSettingTableViewCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


- (UITableViewCell*) personSettingManagerCell:(NSInteger) row
{
    PersonSpaceSettingTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonSpaceSettingTableViewCell"];
    if (!cell)
    {
        cell = [[PersonSpaceSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonSpaceSettingTableViewCell"];
    }
    
    switch (row)
    {
        case PersonManagerFeedbackIndex:
        {
            [cell setTitle:@"意见反馈"];
        }
            break;
        case PersonManagerPasswordIndex:
        {
            [cell setTitle:@"修改密码"];
        }
            break;
            
        case PersonManagerAboutUsIndex:
        {
            [cell setTitle:@"关于我们"];
            break;
        }
        case PersonManagerAccountIndex:
        {
            [cell setTitle:@"账号管理"];
            break;
        }

    }
    return cell;
}

- (UITableViewCell*) personSettingNotificationCell
{
    PersonSpaceSettingNotificationTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonSpaceSettingNotificationTableViewCell"];
    if (!cell)
    {
        cell = [[PersonSpaceSettingNotificationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonSpaceSettingNotificationTableViewCell"];
    }
    
    return cell;
}

- (UITableViewCell*) personSettingLogoutCell
{
    PersonSpaceSettingLogoutTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonSpaceSettingLogoutTableViewCell"];
    if (!cell)
    {
        cell = [[PersonSpaceSettingLogoutTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonSpaceSettingLogoutTableViewCell"];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case PersonSettingLogoutSection:
        {
            //退出用户登录
            [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"我的－设置－退出登录"];
            [[HMViewControllerManager defaultManager] userLogout];
        }
            break;
        case PersonSettingManagereSction:
        {
            switch (indexPath.row)
            {
                    
                case PersonManagerFeedbackIndex:
                {
                    [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"我的－设置－意见反馈"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"PersonSpaceFeedbackViewController" ControllerObject:nil];
                }
                    break;
                    
                case PersonManagerPasswordIndex:
                {
                    [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"我的－设置－修改密码"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"ResetPasswordViewController" ControllerObject:nil];
                }
                    break;
                    
                case PersonManagerAboutUsIndex:
                {
                        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"我的－设置－关于我们"];
                     [HMViewControllerManager createViewControllerWithControllerName:@"PersonSpaceSettingAboutUsViewController" ControllerObject:nil];
                }
                    break;
                case PersonManagerAccountIndex:
                {
                    //跳转到账号管理界面
                    [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"我的－设置－账号管理"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"UserLoginAccountStartViewController" ControllerObject:nil];
                    break;
                }
            }
        }
            break;

        default:
            break;
    }
}
@end
