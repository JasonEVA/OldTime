//
//  HealthPlanMessionStartViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanMessionStartViewController.h"
#import "HealthPlanMessionTableViewController.h"
#import "HealthPlanPendingMessionsViewController.h"
#import "HMSwitchView.h"

@interface HealthPlanMessionStartViewController ()
<HMSwitchViewDelegate>
{
    HMSwitchView* switchview;
    UITabBarController* tabbarController;
}
@end

@implementation HealthPlanMessionStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"健康计划"];
    
    NSArray* undealStatusList = [self undealStatusList];
    if (!undealStatusList || undealStatusList.count == 0) {
        HealthPlanMessionTableViewController* tvcAllStatus = [[HealthPlanMessionTableViewController alloc]initWithStatusList:nil];
        [self addChildViewController:tvcAllStatus];
        [self.view addSubview:tvcAllStatus.tableView];
        [tvcAllStatus.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    else
    {
        [self createSwitchView];
        [self createTabbarController];
    }
    
    if (UMSDK_isOn) {
        [MobClick event:UMCustomEvent_EnterWorkDesk_HealthPlane];
    }
}

- (NSArray*) undealStatusList
{
    NSMutableArray* statusList = [NSMutableArray array];
    
    
    BOOL privilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthPlanMode Status:1 OperateCode:kPrivilegeEditOperate];
    if (privilege)
    {
        //待制定
        [statusList addObject:@"1"];
    }
    
    privilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthPlanMode Status:2 OperateCode:kPrivilegeConfirmOperate];
    if (privilege)
    {
        //待确认
        [statusList addObject:@"2"];
    }
    
    privilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthPlanMode Status:3 OperateCode:kPrivilegeEditOperate];
    if (privilege)
    {
        //待调整
        [statusList addObject:@"3"];
    }
       //    privilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthPlanMode Status:7 OperateCode:kPrivilegeEditOperate];
    //    if (privilege)
    //    {
    //        [statusList addObject:@"7"];
    //    }
    
    return statusList;
}


- (void) createSwitchView
{
    switchview = [[HMSwitchView alloc]init];
    [self.view addSubview:switchview];
    [switchview createCells:@[@"待处理", @"全部"]];
    [switchview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@47);
    }];
    [switchview setDelegate:self];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_image"] style:UIBarButtonItemStylePlain target:self action:@selector(searchItemClick:)];
    [self.navigationItem setRightBarButtonItem:searchItem];
}

- (void)searchItemClick:(id)sender
{
    //跳转搜索界面
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthPlanMessionSearchViewController" ControllerObject:nil];
}

- (void) createTabbarController
{
    tabbarController = [[UITabBarController alloc]init];
    [self addChildViewController:tabbarController];
    
    HealthPlanPendingMessionsViewController* tvcUndealed = [[HealthPlanPendingMessionsViewController alloc]initWithCountBlock:^(NSInteger count) {
        NSString* pendingMessionCount = [NSString stringWithFormat:@"待处理(%ld)", count];
        [switchview setCellTitle:pendingMessionCount index:0];
    }];
    
    
    HealthPlanMessionTableViewController* tvcAllStatus = [[HealthPlanMessionTableViewController alloc]initWithStatusList:nil];
    [tabbarController setViewControllers:@[tvcUndealed, tvcAllStatus]];
    
    [self.view addSubview:tabbarController.view];
    [tabbarController.tabBar setHidden:YES];
    [tabbarController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(switchview.mas_bottom);
    }];
}



#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView *)switchview SelectedIndex:(NSUInteger)selectedIndex
{
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:selectedIndex>0?@"工作台－健康计划－全部":@"工作台－健康计划－待处理"];
    if (tabbarController)
    {
        [tabbarController setSelectedIndex:selectedIndex];
    }
}


@end
