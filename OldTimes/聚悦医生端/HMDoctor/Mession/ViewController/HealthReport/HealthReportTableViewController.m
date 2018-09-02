//
//  HealthReportTableViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HealthReportTableViewController.h"
#import "HealthReportListTableViewCell.h"

const NSInteger kHealthReportMessionPageSize = 20;

@interface HealthReportTableViewController ()
<TaskObserver>
{
    NSMutableArray* healthReports;
    NSInteger totalCount;
}
@property (nonatomic, readonly) NSArray* statusList;
@end

@implementation HealthReportTableViewController

- (id) initWithStatusList:(NSArray*) statusList
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _statusList = statusList;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //刷新列表
    [self loadHealthReportList];
    
}

- (void) loadHealthReportList
{
    if (_statusList && _statusList.count == 0) {
        //没有处理权限
        [self showBlankView];
        return;
    }
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.userId] forKey:@"staffUserId"];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    NSInteger rows = kHealthReportMessionPageSize;
    if (healthReports && 0 < healthReports.count) {
        rows = healthReports.count;
    }
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    if (_statusList)
    {
        [dicPost setValue:_statusList forKey:@"status"];
    }
    [self.tableView.superview showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthReportListTask" taskParam:dicPost TaskObserver:self];
}

- (void) loadMoreHealthReportList
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.userId] forKey:@"staffUserId"];
    NSInteger startRow = 0;
    if (healthReports)
    {
        startRow = healthReports.count;
    }
    [dicPost setValue:[NSNumber numberWithInteger:startRow] forKey:@"startRow"];
    
    NSInteger rows = kHealthReportMessionPageSize;
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    if (_statusList)
    {
        [dicPost setValue:_statusList forKey:@"status"];
    }
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthReportListTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (healthReports)
    {
        return healthReports.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 147;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HealthReportListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthReportListTableViewCell"];
    if (!cell)
    {
        cell = [[HealthReportListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthReportListTableViewCell"];
    }
    
    // Configure the cell...
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    HealthReportInfo* report = healthReports[indexPath.row];
    [cell setHealthReport:report];
    
    [cell.operateButton setTag:0x200 + indexPath.row];
    [cell.operateButton addTarget:self action:@selector(reportDealButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthReportInfo* report = healthReports[indexPath.row];
    
    BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthReportMode Status:report.status OperateCode:kPrivilegeViewOperate];
    if (!viewPrivilege)
    {
        //没有查看健康报告权限
        return;
    }
    //跳转到健康报告详情页面
    if (report.status == 2)
    {
        
    }
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthReportDetailViewController" ControllerObject:[NSString stringWithFormat:@"%@", report.healthyReportId]];
}

- (void) reportDealButtonClicked:(id) sender
{
    if (![sender isKindOfClass:[UIButton class]])
    {
        return;
    }
    
    UIButton* btn = (UIButton*) sender;
    NSInteger tagIndex = btn.tag - 0x200;
     HealthReportInfo* report = healthReports[tagIndex];

    //
    BOOL editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthReportMode Status:report.status OperateCode:kPrivilegeEditOperate];
    if (!editPrivilege)
    {
        //没有查看健康报告权限
        return;
    }
    
    //跳转到编辑健康报告详情页面
    if (2 == report.status)
    {
        StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
        if (report.summarizeUserId != staff.userId)
        {
            [self showAlertMessage:@"不是指定给您的。"];
            return;
        }
    }
    
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthReportEditViewController" ControllerObject:report];
}

- (void) healthReportListLoaded:(NSArray*) items
{
    
    healthReports = [NSMutableArray arrayWithArray:items];
    [self.tableView reloadData];
    
    if (healthReports.count >= totalCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData ];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreHealthReportList)];
    }

}

- (void) moreHealthReportListLoaded:(NSArray*) items
{
    if (!healthReports)
    {
        healthReports = [NSMutableArray array];
    }
    [healthReports addObjectsFromArray:items];
    [self.tableView reloadData];
    
    if (healthReports.count >= totalCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData ];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreHealthReportList)];
    }
    
}

#pragma mark - TaskObserver

- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView.superview closeWaitView];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"HealthReportListTask"])
    {
        NSDictionary* dicPost = [TaskManager taskparamWithTaskId:taskId];
        if (dicPost && [dicPost isKindOfClass:[NSDictionary class]])
        {
            NSNumber* numStartRow = [dicPost valueForKey:@"startRow"];
            if (numStartRow && [numStartRow isKindOfClass:[NSNumber class]] && numStartRow.integerValue == 0)
            {
                [self.tableView.mj_header endRefreshing];
            }
            else
            {
                if (totalCount <= healthReports.count)
                {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                else
                {
                    [self.tableView.mj_footer endRefreshing];
                }
            }
        }
        
        
        if (!totalCount || 0 == healthReports.count)
        {
            [self showBlankView];
        }
        else
        {
            [self closeBlankView];
        }

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
    
    if ([taskname isEqualToString:@"HealthReportListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            
            NSNumber* numCount = [dicResult valueForKey:@"count"];
            if (numCount && [numCount isKindOfClass:[NSNumber class]])
            {
                totalCount = numCount.integerValue;
            }
            
            NSArray *items = [dicResult valueForKey:@"list"];
            
            NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
            
            
            NSNumber* numStart = [dicParam valueForKey:@"startRow"];
            if (numStart && [numStart isKindOfClass:[NSNumber class]] && 0 < numStart.integerValue)
            {
                //加载更多
                [self moreHealthReportListLoaded:items];
                
            }
            else
            {
                [self healthReportListLoaded:items];
            }
            
        }

    }
}

@end
