//
//  AttentionStaffListTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AttentionStaffListTableViewController.h"
#import "AttentionStaffTableViewCell.h"

#define kAttentionStaffListPageSie      20

@interface AttentionStaffListTableViewController ()
<TaskObserver>
{
    NSInteger totalCount;
    NSMutableArray* attentionStaffs;
}
@end

@implementation AttentionStaffListTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadAttentionStaffList)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void) loadAttentionStaffList
{
    //AttentionStaffListTask
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    NSInteger rows = kAttentionStaffListPageSie;
    if (attentionStaffs && 0 < attentionStaffs.count)
    {
        rows = attentionStaffs.count;
    }
    [dicPost setValue:[NSNumber numberWithInteger:kAttentionStaffListPageSie] forKey:@"rows"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"AttentionStaffListTask" taskParam:dicPost TaskObserver:self];
}

- (void) loadMoreAttentionStaffList
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    NSInteger startRows = 0;
    if (attentionStaffs)
    {
        startRows = attentionStaffs.count;
    }
    
    [dicPost setValue:[NSNumber numberWithInteger:startRows] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kAttentionStaffListPageSie] forKey:@"rows"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"AttentionStaffListTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaffInfo* staff = attentionStaffs[indexPath.row];
    [HMViewControllerManager createViewControllerWithControllerName:@"StaffDetailViewController" ControllerObject:staff];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (attentionStaffs)
    {
        return attentionStaffs.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AttentionStaffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttentionStaffTableViewCell"];
    if (!cell)
    {
        cell = [[AttentionStaffTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AttentionStaffTableViewCell"];
    }
    
    // Configure the cell...
    StaffInfo* staff = attentionStaffs[indexPath.row];
    [cell setStaffInfo:staff];
    
    return cell;
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
    
    
    if (attentionStaffs.count < totalCount)
    {
        if (self.tableView.mj_footer)
        {
            [self.tableView.mj_footer endRefreshing];
        }
        
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAttentionStaffList)];
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
    
    if ([taskname isEqualToString:@"AttentionStaffListTask"])
    {
        NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
        if (dicParam && [dicParam isKindOfClass:[NSDictionary class]])
        {
            NSNumber* numStart = [dicParam valueForKey:@"startRow"];
            if (numStart && [numStart isKindOfClass:[NSNumber class]] && 0 == numStart.integerValue)
            {
                attentionStaffs = [NSMutableArray array];
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
                [attentionStaffs addObjectsFromArray:lspReports];
            }
            
        }
        
        
    }
}


@end
