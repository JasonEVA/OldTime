//
//  PersonSpaceTableViewController.m
//  HMClient
//
//  Created by lkl on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonSpaceTableViewController.h"
#import "PersonSpaceCommonTableViewCell.h"

typedef enum : NSUInteger {
    PersonSpaceInfoSection,
    PerSonSpaceSecviceSection,
    PersonSpaceManagerSection,
    PersonSpaceSystemSection,
    PersonSpaceMaxIndex,
}personSpaceTableSection;

@interface PersonSpaceTableViewController ()

@end

@implementation PersonSpaceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor lightGrayColor]];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView setSeparatorColor:[UIColor colorWithHexString:@"E2E2E2"]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return PersonSpaceMaxIndex;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    float headerHeight = 0;
    switch (section)
    {
        case PersonSpaceInfoSection:
            headerHeight = 55;
            break;
            
        case PerSonSpaceSecviceSection:
            headerHeight = 10;
            break;
            
        case PersonSpaceManagerSection:
            headerHeight = 10;
            break;
            
        case PersonSpaceSystemSection:
            headerHeight = 0.5;
            break;
            
        default:
            break;
    }
    return headerHeight;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = nil;
    switch (section)
    {
        case PersonSpaceInfoSection:
        {
            footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 14)];
            [footerView setBackgroundColor:[UIColor whiteColor]];
            
            UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 20)];
            [lbTitle setText:@"我的服务"];
            [lbTitle setFont:[UIFont systemFontOfSize:12]];
            [footerView addSubview:lbTitle];
            
            UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [historyBtn setFrame:CGRectMake(240, 10, 80, 20)];
            [historyBtn setTitle:@"历史订购>" forState:UIControlStateNormal];
            [historyBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [historyBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:historyBtn];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lbTitle.frame)+5, 10, 10)];
            [img setImage:[UIImage imageNamed:@"img_default_maingird"]];
            [footerView addSubview:img];
            
            UILabel *lbVIP = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lbTitle.frame)+5, 100, 20)];
            [lbVIP setText:@"慢病康复VIP服务"];
            [lbVIP setFont:[UIFont systemFontOfSize:12]];
            [footerView addSubview:lbVIP];
            
            UILabel *serviceDate = [[UILabel alloc] initWithFrame:CGRectMake(160, CGRectGetMaxY(lbTitle.frame)+5, 120, 20)];
            [serviceDate setText:@"服务期至2017-02-28"];
            [serviceDate setTextColor:[UIColor lightGrayColor]];
            [serviceDate setFont:[UIFont systemFontOfSize:12]];
            [footerView addSubview:serviceDate];
        }
            break;
            
        case PersonSpaceSystemSection:
        {
            footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
            [footerView setBackgroundColor:[UIColor lightGrayColor]];
        }
            break;
            
        default:
            break;
    }
    
    return footerView;
}

- (void)click
{
    NSLog(@"22");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    self.cellHeight = 0;
    switch (indexPath.section)
    {
        case PersonSpaceInfoSection:
            self.cellHeight = 80;
            break;
            
        case PerSonSpaceSecviceSection:
            self.cellHeight = 80;
            break;
            
        case PersonSpaceManagerSection:
            self.cellHeight = 135;
            break;
            
        case PersonSpaceSystemSection:
            self.cellHeight = 60;
            break;
            
        default:
            break;
    }
    return self.cellHeight;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case PersonSpaceInfoSection:
            cell = [self personInfoTableViewCell];
            [cell setBackgroundColor:[UIColor lightGrayColor]];
            break;
            
        case PerSonSpaceSecviceSection:
        case PersonSpaceManagerSection:
        case PersonSpaceSystemSection:
            cell = [self PersonSpaceCommonCell:indexPath];
            break;
            
        default:
            break;
    }
    
    
    return cell;
}

- (personInfoTableViewCell*) personInfoTableViewCell
{
    personInfoTableViewCell *cell = (personInfoTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"personInfoTableViewCell"];
    if (!cell)
    {
        cell = [[personInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personInfoTableViewCell"];
    }
    [cell updateUserInfo];
    return cell;
}


- (PersonSpaceCommonTableViewCell*) PersonSpaceCommonCell:(NSIndexPath*)indexPath
{
    PersonSpaceCommonTableViewCell *cell = (PersonSpaceCommonTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"PersonSpaceCommonTableViewCell"];
    if (!cell)
    {
        cell = [[PersonSpaceCommonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonSpaceCommonTableViewCell"];
        cell.index = indexPath.section;
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case PersonSpaceInfoSection:
        {
            [HMViewControllerManager createViewControllerWithControllerName:@"PersonSettingStartViewController" ControllerObject:nil];
        }
            break;
            
        default:
            break;
    }
}


@end

