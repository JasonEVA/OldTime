//
//  HealthReportListTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthReportListTableViewController.h"
#import "HealthReportTableViewCell.h"

@interface HealthReportListStartViewController ()
{
    HealthReportListTableViewController* tvcReport;
}
@end

@implementation HealthReportListStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"健康报告"];
    
    tvcReport = [[HealthReportListTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcReport];
    [self.view addSubview:tvcReport.tableView];
    [tvcReport.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
}

@end

#define kHealthReportListPageSize           20

@interface HealthReportListTableViewController ()
<TaskObserver>
{
    NSInteger totalCount;
    NSMutableArray* reports;
}
@end

@implementation HealthReportListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHealthReportList)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];

}

- (void) loadHealthReportList
{
    //HealthReportListTask
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    NSInteger rows = kHealthReportListPageSize;
    if (reports && 0 < reports.count)
    {
        rows = reports.count;
    }
    [dicPost setValue:[NSNumber numberWithInteger:kHealthReportListPageSize] forKey:@"rows"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthReportListTask" taskParam:dicPost TaskObserver:self];
}

- (void) loadMoreHealthReportList
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    NSInteger startRows = 0;
    if (reports)
    {
        startRows = reports.count;
    }
    
    [dicPost setValue:[NSNumber numberWithInteger:startRows] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kHealthReportListPageSize] forKey:@"rows"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthReportListTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 20)];
    UIView* lineview = [[UIView alloc]init];
    [headerview addSubview:lineview];
    [lineview setBackgroundColor:[UIColor mainThemeColor]];
    
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@1);
        make.top.and.bottom.equalTo(headerview);
        make.left.equalTo(headerview).with.offset(51);
    }];
    
    return headerview;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (reports)
    {
        return reports.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HealthReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthReportTableViewCell"];
    if (!cell)
    {
        cell = [[HealthReportTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthReportTableViewCell"];
    }
    // Configure the cell...
    HealthReport* report = reports[indexPath.row];
    [cell setHealthReport:report];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthReport* report = reports[indexPath.row];
    //跳转到健康报告详情页面
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthReportDetailViewController" ControllerObject:report.healthyReportId];
}

- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView.mj_header endRefreshing];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    [self.tableView reloadData];
    
    
    if (reports.count < totalCount)
    {
        if (self.tableView.mj_footer)
        {
            [self.tableView.mj_footer endRefreshing];
        }
        
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreHealthReportList)];
    }
    else
    {
        if (self.tableView.mj_footer)
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
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
        NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
        if (dicParam && [dicParam isKindOfClass:[NSDictionary class]])
        {
            NSNumber* numStart = [dicParam valueForKey:@"startRow"];
            if (numStart && [numStart isKindOfClass:[NSNumber class]] && 0 == numStart.integerValue)
            {
                reports = [NSMutableArray array];
            }
        }
        
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResp = (NSDictionary*) taskResult;
            NSNumber* numCount = [dicResp valueForKey:@"count"];
            if (numCount && [numCount isKindOfClass:[NSNumber class]])
            {
                totalCount = numCount.integerValue;
            }
            
            NSArray* lspReports = [dicResp valueForKey:@"list"];
            if (lspReports && [lspReports isKindOfClass:[NSArray class]])
            {
                [reports addObjectsFromArray:lspReports];
            }
            
        }
        
        
    }
}

@end
