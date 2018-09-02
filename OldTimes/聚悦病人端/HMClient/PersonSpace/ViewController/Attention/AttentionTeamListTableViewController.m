//
//  AttentionTeamListTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AttentionTeamListTableViewController.h"
#import "DoctorTeamTableViewCell.h"

#define kAttentionTeamListPageSie           20

@interface AttentionTeamListTableViewController ()
<TaskObserver>
{
    NSInteger totalCount;
    NSMutableArray* attentionTeams;
}
@end

@implementation AttentionTeamListTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadAttentionTeamList)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadAttentionTeamList
{
    //AttentionStaffListTask
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    NSInteger rows = kAttentionTeamListPageSie;
    if (attentionTeams && 0 < attentionTeams.count)
    {
        rows = attentionTeams.count;
    }
    [dicPost setValue:[NSNumber numberWithInteger:kAttentionTeamListPageSie] forKey:@"rows"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"AttentionTeamListTask" taskParam:dicPost TaskObserver:self];
}

- (void) loadMoreAttentionTeamList
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    NSInteger startRows = 0;
    if (attentionTeams)
    {
        startRows = attentionTeams.count;
    }
    
    [dicPost setValue:[NSNumber numberWithInteger:startRows] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kAttentionTeamListPageSie] forKey:@"rows"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"AttentionTeamListTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (attentionTeams)
    {
        return attentionTeams.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DoctorTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorTeamTableViewCell"];
    if (!cell)
    {
        cell = [[DoctorTeamTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DoctorTeamTableViewCell"];
    }
    // Configure the cell...
    TeamInfo* team = attentionTeams[indexPath.row];
    [cell setTeamInfo:team];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamInfo* team = attentionTeams[indexPath.row];
    //跳转到团队界面
    [HMViewControllerManager createViewControllerWithControllerName:@"TeamDetailViewController" ControllerObject:team];
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
    
    
    if (attentionTeams.count < totalCount)
    {
        if (self.tableView.mj_footer)
        {
            [self.tableView.mj_footer endRefreshing];
        }
        
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAttentionTeamList)];
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
    
    if ([taskname isEqualToString:@"AttentionTeamListTask"])
    {
        NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
        if (dicParam && [dicParam isKindOfClass:[NSDictionary class]])
        {
            NSNumber* numStart = [dicParam valueForKey:@"startRow"];
            if (numStart && [numStart isKindOfClass:[NSNumber class]] && 0 == numStart.integerValue)
            {
                attentionTeams = [NSMutableArray array];
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
                [attentionTeams addObjectsFromArray:lspReports];
            }
            
        }
        
        
    }
}


@end
