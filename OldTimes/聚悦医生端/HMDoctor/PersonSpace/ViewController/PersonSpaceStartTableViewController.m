//
//  PersonSpaceStartTableViewController.m
//  HMDoctor
//
//  Created by yinquan on 16/4/11.
//  Copyright © 2016年 yinquan. All rights reserved.
//
#import "PersonSpaceStartTableViewController.h"
//#import "PersonStaffFunsTableViewCell.h"
#import "PersonSpaceStartAccountTableViewCell.h"

#import "PersonSpaceStartLogoutTableViewCell.h"
#import "PersonStartManageTableViewCell.h"


typedef enum : NSUInteger {
    //PersonSpace_PersonInfoSection,
    PersonSpace_AccountSection,
    PersonSpace_ManagerSection,
    PersonSpace_AddressBookSection,
    PersonSpace_SettingSection,
    //PersonSpace_LogoutSection,
    PersonSpace_SectionCount,
} PersonSpaceTableSection;

typedef enum : NSUInteger {
    PersonManager_AppointIndex,
    PersonManager_ServiceIndex,
    //PersonManager_CollectionIndex,
    PersonManagerIndexCount,
} PersonManagerIndex;

@interface PersonSpaceStartTableViewController ()<TaskObserver>
{
//    UIImageView *navBarHairlineImageView;
//    PersonSpaceNavigationView* navTitleView;
    //PersonStartGirdsCollectionViewController* vcGirdList;
    
    NSString* estimatePrice;
    NSString* accountSum;
}
@end

@implementation PersonSpaceStartTableViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    [dicPost setValue:@"4" forKey:@"type"];
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    if (curStaff)
    {
        [dicPost setValue:[NSString stringWithFormat:@"%ld",curStaff.staffId] forKey:@"objId"];
    }
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserAccountTask" taskParam:dicPost TaskObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //[self.navigationItem setTitle:@"我的"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return PersonSpace_SectionCount;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12 * kScreenScale;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    return footerview;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {

        case PersonSpace_AccountSection:
        {
            return 106 * kScreenScale;
        }
            break;
        case PersonSpace_ManagerSection:
        case PersonSpace_AddressBookSection:
        case PersonSpace_SettingSection:
        {
            return 42 * kScreenScale;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    switch (section)
    {
        case PersonSpace_AccountSection:
        //case PersonSpace_OpeaateSection:
        case PersonSpace_AddressBookSection:
        case PersonSpace_SettingSection:
            return 1;
            break;
        case PersonSpace_ManagerSection:
        {
            return PersonManagerIndexCount;
        }
            break;
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case PersonSpace_AccountSection:
        {
            cell = [self accountInfoCell];
        }
            break;
        case PersonSpace_ManagerSection:
        {
            cell = [self manageCell:indexPath.row];
        }
            break;
        case PersonSpace_AddressBookSection:
        {
            cell = [self addressBookCell];
        }
            break;
        case PersonSpace_SettingSection:
        {
            cell = [self settingCell];
        }
            break;
        default:
            break;
    }
    // Configure the cell...
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonSpaceStartTableViewCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}



- (UITableViewCell*) accountInfoCell
{
    PersonSpaceStartAccountTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonSpaceStartAccountTableViewCell"];
    if (!cell)
    {
        cell = [[PersonSpaceStartAccountTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonSpaceStartAccountTableViewCell"];
    }

    if (accountSum || estimatePrice)
    {
        [cell setAccount:accountSum.doubleValue EstimatedIncome:estimatePrice.doubleValue];
    }

    return cell;
}

- (UITableViewCell*) manageCell:(NSInteger) index
{
    PersonStartManageTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonStartManageTableViewCell"];
    if (!cell)
    {
        cell = [[PersonStartManageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonStartManageTableViewCell"];
        //[cell.contentView addSubview:vcGirdList.collectionView];
    }
   
    switch (index)
    {
        case PersonManager_AppointIndex:
        {
            [cell setName:@"我的约诊" Icon:[UIImage imageNamed:@"ic_person_appoint"]];
        }
            break;
        case PersonManager_ServiceIndex:
        {
            [cell setName:@"我的服务" Icon:[UIImage imageNamed:@"ic_person_service"]];
        }
            break;
        /*case PersonManager_CollectionIndex:
        {
            [cell setName:@"我的收藏" Icon:[UIImage imageNamed:@"ic_person_collection"]];
        }*/
            break;
        default:
            break;
    }

    return cell;

}

- (UITableViewCell*) addressBookCell
{
    PersonStartManageTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonStartManageTableViewCell"];
    if (!cell)
    {
        cell = [[PersonStartManageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonStartManageTableViewCell"];
    }
    [cell setName:@"医院通讯录" Icon:[UIImage imageNamed:@"ic_person_addressbook"]];
    return cell;
}

- (UITableViewCell*) settingCell
{
    PersonStartManageTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonStartManageTableViewCell"];
    if (!cell)
    {
        cell = [[PersonStartManageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonStartManageTableViewCell"];
        
    }
    [cell setName:@"设置" Icon:[UIImage imageNamed:@"ic_person_setting"]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case PersonSpace_SettingSection:
        {
            //PersonSpaceSettingViewController
            [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"我的－设置"];
            [HMViewControllerManager createViewControllerWithControllerName:@"PersonSpaceSettingViewController" ControllerObject:nil];
        }
            break;
            
        case PersonSpace_AddressBookSection:
        {
            [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"我的－医院通讯录"];
            [HMViewControllerManager createViewControllerWithControllerName:@"PersonSpaceAddressBookViewController" ControllerObject:nil];
        }
            break;
            
            
            case PersonSpace_ManagerSection:
        {
            switch (indexPath.row)
            {
                case PersonManager_AppointIndex:
                {
                    
                    //跳转到约诊详情 AppointmentStartViewController
                    [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"我的－我的约诊"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentStartViewController" ControllerObject:nil];
                }
                    break;
                case PersonManager_ServiceIndex:
                {
                    //跳转到我的服务 StaffServiceStartViewController
                        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"我的－我的服务"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"StaffServiceStartViewController" ControllerObject:nil];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [[self.tableView superview] closeWaitView];
    if (StepError_None != taskError) {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"UserAccountTask"])
    {

        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            
            //预计收益
            estimatePrice = [dicResult valueForKey:@"estimatePrice"];
            
            //余额
            NSDictionary* dicUserAccount = [dicResult valueForKey:@"userAccount"];
            if (dicUserAccount && [dicUserAccount isKindOfClass:[NSDictionary class]])
            {
                accountSum = [dicUserAccount valueForKey:@"accountSum"];
            }
            
            
            if (!accountSum)
            {
                NSLog(@"no accountSum");
            }
        }

        //NSLog(@"%@",taskResult);
/*        NSDictionary* dicResult = (NSDictionary*) taskResult;
        
        //预计收益
        estimatePrice = [dicResult valueForKey:@"estimatePrice"];
        if (![estimatePrice isKindOfClass:[NSString class]]) {
            estimatePrice = @"";
        }
        //余额
        NSDictionary* dicUserAccount = [dicResult valueForKey:@"userAccount"];
        accountSum = [dicUserAccount valueForKey:@"accountSum"];
        if (![accountSum isKindOfClass:[NSString class]]) {
            accountSum = @"";
        }*/

        [self.tableView reloadData];
    }
}


@end
