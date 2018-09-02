//
//  PersonSettingTableViewController.m
//  HMClient
//
//  Created by lkl on 16/4/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonSettingTableViewController.h"
#import "PersonSettingTableViewCell.h"
#import "NewbieGuideInteractor.h"

typedef enum : NSInteger
{
    PersonSettingSection,
    PersonNewbieGuideSection,
    PersonMessageSection,
    PersonExitSection,
    PersonMaxCount,
    
}EPersonSettingSection;

typedef enum : NSInteger
{
    PersonInfoSettingIndex,
    PersonPasswordIndex,
    PersonSettingMaxIndex,
}EPersonSettingIndex;

@interface PersonSettingTableViewController ()

@end

@implementation PersonSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    //self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //[self.tableView setSeparatorColor:[UIColor colorWithHexString:@"E2E2E2"]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return PersonMaxCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case PersonSettingSection:
            return PersonSettingMaxIndex;
            break;
            
        case PersonNewbieGuideSection:
        case PersonMessageSection:
        case PersonExitSection:
            return 1;
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section)
    {
        case PersonSettingSection:
        case PersonNewbieGuideSection:
            return 16;
            break;
            
        case PersonMessageSection:
            return 55;
            
        case PersonExitSection:
            return 0.5;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = nil;
    switch (section)
    {
        case PersonNewbieGuideSection:
        case PersonSettingSection:
        {
            footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 16)];
        }
            break;
        case PersonMessageSection:
        {
            footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 14)];
            
            UILabel *lbContent = [[UILabel alloc] initWithFrame:CGRectMake(12.5, 10, kScreenWidth - 25, 20)];
            [lbContent setText:@"您可以在手机设置->通知中心里进行设置"];
            [lbContent setTextColor:[UIColor commonLightGrayTextColor]];
            [lbContent setFont:[UIFont font_22]];
            [footerView addSubview:lbContent];
        }
            break;
            
        case PersonExitSection:
        {
             footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
             //[footerView setBackgroundColor:[UIColor lightGrayColor]];
        }
             break;
            
        default:
            break;
    }
    if (footerView)
    {
        [footerView setBackgroundColor:[UIColor commonBackgroundColor]];
    }
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case PersonSettingSection:
            cell = [self PersonSettingCell:indexPath];
            break;
            
        case PersonNewbieGuideSection: {
            cell = [self personNewbieGuideCell];
            break;
        }

        case PersonMessageSection:
            cell = [self PersonMessageTableCell];
            break;
            
        case PersonExitSection:
            cell = [self PersonExitTableCell];
            break;
            
        default:
            break;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (PersonSettingTableViewCell*)personNewbieGuideCell
{
    PersonSettingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonNewbieGuideCell"];
    if (!cell)
    {
        cell = [[PersonSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonNewbieGuideCell"];
    }
    
    [cell settextContent:@"新手引导"];
    return cell;
}


- (PersonSettingTableViewCell*)PersonSettingCell:(NSIndexPath*)indexPath
{
    PersonSettingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonSettingTableViewCell"];
    if (!cell)
    {
        cell = [[PersonSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonSettingTableViewCell"];
    }
    
    switch (indexPath.row)
    {
        case PersonInfoSettingIndex:
        {
            
            [cell settextContent:@"个人信息设置"];
        }
            break;
            
        case PersonPasswordIndex:
        {
            
            [cell settextContent:@"修改密码"];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (PersonMessageTableViewCell*)PersonMessageTableCell
{
    PersonMessageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonMessageTableViewCell"];
    if (!cell)
    {
        cell = [[PersonMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonMessageTableViewCell"];
    }
    
    
    [cell settextContent:@"新消息提示"];
    
    return cell;
}

- (PersonExitTableViewCell*)PersonExitTableCell
{
    PersonExitTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonExitTableViewCell"];
    if (!cell)
    {
        cell = [[PersonExitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonExitTableViewCell"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case PersonSettingSection:
        {
            switch (indexPath.row)
            {
                case PersonInfoSettingIndex:
                {
                    //个人信息设置
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"设置－个人信息设置"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"PersonInfoViewController" ControllerObject:nil];
                }
                    break;
                    
                case PersonPasswordIndex:
                {
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"设置－修改密码"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"ResetPasswordViewController" ControllerObject:nil];
                }
                    break;

                default:
                    break;
            }
        }
            break;
            
        case PersonNewbieGuideSection:
        {
            // 新手指引
            [NewbieGuideInteractor presentNewbieGuideWithGuideType:NewbieGuidePageTypeAddBloodPressure presentingViewController:self animated:NO];
            break;
        }

        case PersonExitSection:
        {
            [[HMViewControllerManager defaultManager] userLogout];
        }
            
            break;
            
        default:
            break;
    }
}


@end
