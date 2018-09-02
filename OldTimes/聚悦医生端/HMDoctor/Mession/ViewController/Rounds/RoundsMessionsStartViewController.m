//
//  RoundsMessionsStartViewController.m
//  HMDoctor
//
//  Created by yinquan on 16/9/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "RoundsMessionsStartViewController.h"
#import "HMSwitchView.h"
#import "RoundsMessionsTableViewController.h"


@interface RoundsMessionsStartViewController ()
<HMSwitchViewDelegate,
TaskObserver>
{
    HMSwitchView* switchview;
    UITabBarController* tabbarController;
}
@end

@implementation RoundsMessionsStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"查房"];
    [self createSwitchView];
    
    tabbarController = [[UITabBarController alloc]init];
    [self addChildViewController:tabbarController];
    //待处理
    NSArray* undealstatusList = [self undealRoundsStatus];
    RoundsMessionsTableViewController* tvcUndealed = [[RoundsMessionsTableViewController alloc]initWithStatusList:undealstatusList];
    //全部
    RoundsMessionsTableViewController* tvcAllMession = [[RoundsMessionsTableViewController alloc]initWithStatusList:nil];
    [tabbarController setViewControllers:@[tvcUndealed, tvcAllMession]];
    [self.view addSubview:tabbarController.view];
    [tabbarController.tabBar setHidden:YES];
    [tabbarController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(switchview.mas_bottom);
    }];
    
    if (UMSDK_isOn) {
        [MobClick event:UMCustomEvent_EnterWorkDesk_Check];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //获取待处理数量
    
    
    //RoundsMessionsCountTask
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];

    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSArray* undealstatusList = [self undealRoundsStatus];
    if (undealstatusList && 0 == undealstatusList.count)
    {
        //没有可处理的状态
        [switchview setCellTitle:[NSString stringWithFormat:@"待处理(0)"] index:0];
        return;
    }
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    [dicPost setValue:undealstatusList forKey:@"statusList"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"RoundsMessionsCountTask" taskParam:dicPost TaskObserver:self];
}

- (void) createSwitchView
{
    switchview = [[HMSwitchView alloc]init];
    [self.view addSubview:switchview];
    [switchview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self.view);
        make.height.mas_equalTo(@49);
    }];
    
    [switchview setDelegate:self];
    
    [switchview createCells:@[@"待处理", @"全部"]];
}

- (NSArray*) undealRoundsStatus
{
    NSMutableArray* undealStatus = [NSMutableArray array];
    BOOL editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeRoundsMode Status:0 OperateCode:kPrivilegeEditOperate];
    if (editPrivilege)
    {
        [undealStatus addObject:@"0"];
    }
    return undealStatus;
}

#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSUInteger) selectedIndex
{    
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:selectedIndex>0?@"工作台－查房－全部":@"工作台－查房－已填写"];
    [tabbarController setSelectedIndex:selectedIndex];
}

#pragma mark TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    
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
    
    if ([taskname isEqualToString:@"RoundsMessionsCountTask"])
    {
        //获取到已填写的评估总数
        if (taskResult && [taskResult isKindOfClass:[NSNumber class]])
        {
            if (switchview)
            {
                NSNumber* numCount = (NSNumber*)taskResult;
                [switchview setCellTitle:[NSString stringWithFormat:@"待处理(%ld)", numCount.integerValue] index:0];
            }
        }
    }
}

@end
