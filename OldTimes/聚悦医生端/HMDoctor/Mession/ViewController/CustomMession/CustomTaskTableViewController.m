//
//  CustomTaskTableViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CustomTaskTableViewController.h"
#import "HMSwitchView.h"
#import "CustomTaskTableViewCell.h"
#import "UserScheduleInfo.h"

@interface CustomTaskViewController ()
<HMSwitchViewDelegate>
{
    HMSwitchView* switchview;
    CustomTaskTableViewController *tvcCustomTask;
    
    NSString *selectType;
}
@end

#define kCustomTaskPageSize 20

@interface CustomTaskTableViewController ()<TaskObserver>
{
    NSInteger totalCount;
    NSMutableArray *customTasks;
}
- (void) setCustomTaskType:(NSString*) type;

@end

@implementation CustomTaskViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"自定义任务"];
    
    UIButton* addTaskBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [addTaskBtn setImage:[UIImage imageNamed:@"icon_home_add"] forState:UIControlStateNormal];
    [addTaskBtn addTarget:self action:@selector(addTaskBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* bbAddTask = [[UIBarButtonItem alloc]initWithCustomView:addTaskBtn];
    [self.navigationItem setRightBarButtonItem:bbAddTask];
    
    
    [self createSwitchView];
    
    [self createCustomTaskTable];
    if (UMSDK_isOn) {
        [MobClick event:UMCustomEvent_EnterWorkDesk_CustomMission];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self createSwitchView];
    [tvcCustomTask setCustomTaskType:@"1"];
}

- (void)addTaskBtnClick
{
    [HMViewControllerManager createViewControllerWithControllerName:@"CustomTaskAddViewController" ControllerObject:nil];
}

- (void) createSwitchView
{
    switchview = [[HMSwitchView alloc]init];
    [self.view addSubview:switchview];

    [switchview createCells:@[@"未过期", @"全部"]];
    
    [switchview setDelegate:self];
    
    [switchview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@49);
    }];
}

- (void) createCustomTaskTable
{
    tvcCustomTask = [[CustomTaskTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcCustomTask];
    [self.view addSubview:tvcCustomTask.tableView];

    [tvcCustomTask.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(switchview.mas_bottom);
    }];
    
    [tvcCustomTask setCustomTaskType:@"1"];
}


#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView *)switchview SelectedIndex:(NSUInteger)selectedIndex
{
    
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:selectedIndex>0?@"工作台－自定义任务－全部":@"工作台－自定义任务－未过期"];
    switch (selectedIndex)
    {
        case 0:
        {
            [tvcCustomTask setCustomTaskType:@"1"];
        }
            break;
        case 1:
        {
            [tvcCustomTask setCustomTaskType:@"0"];
        }
            break;
        default:
            break;
    }
}


@end



@implementation CustomTaskTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void) setCustomTaskType:(NSString*) type
{
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", curStaff.userId] forKey:@"userId"];
    
    [dicPost setValue:type forKey:@"type"];
    
    NSInteger rows = kCustomTaskPageSize;
    if (customTasks && 0 < customTasks.count)
    {
        rows = customTasks.count;
    }
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kCustomTaskPageSize] forKey:@"rows"];
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserScheduleListTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return customTasks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserScheduleInfo *useSchedule = [customTasks objectAtIndex:indexPath.row];
    
    CustomTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTaskTableViewCell"];
    
    if (!cell) {
        cell = [[CustomTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomTaskTableViewCell"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell setUserScheduleInfo:useSchedule];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserScheduleInfo *useSchedule = [customTasks objectAtIndex:indexPath.row];
    
    [HMViewControllerManager createViewControllerWithControllerName:@"SchedulesDetailViewController" ControllerObject:useSchedule];
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
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
    
    if ([taskname isEqualToString:@"UserScheduleListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            
            NSNumber* numCount = [dicResult valueForKey:@"count"];
            if (numCount && [numCount isKindOfClass:[NSNumber class]])
            {
                totalCount = numCount.integerValue;
            }
            
            NSArray *list = dicResult[@"list"];
            
            NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
            NSNumber* numStart = [dicParam valueForKey:@"startRow"];
            if (numStart && [numStart isKindOfClass:[NSNumber class]] && 0 < numStart.integerValue)
            {
                //加载
                [self moreCustomTaskListLoaded:list];
                return;
            }
            else
            {
                [self customTaskListLoaded:list];
            }
        }
    }
}

- (void) customTaskListLoaded:(NSArray*) items
{
    customTasks = [NSMutableArray arrayWithArray:items];
    [self.tableView reloadData];
    
    if (customTasks.count >= totalCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData ];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCustomTaskItem)];
    }
    
}

- (void) moreCustomTaskListLoaded:(NSArray*) items
{
    if (!customTasks)
    {
        customTasks = [NSMutableArray array];
    }
    [customTasks addObjectsFromArray:items];
    [self.tableView reloadData];
    
    if (customTasks.count >= totalCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData ];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCustomTaskItem)];
    }
}

- (void) loadMoreCustomTaskItem
{
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    [dicPost setValue:@"0" forKey:@"type"];
    
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", curStaff.userId] forKey:@"userId"];
    
    if (customTasks)
    {
        [dicPost setValue:[NSNumber numberWithLong:customTasks.count] forKey:@"startRow"];
    }

    [dicPost setValue:[NSNumber numberWithInteger:kCustomTaskPageSize] forKey:@"rows"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserScheduleListTask" taskParam:dicPost TaskObserver:self];
}

@end
