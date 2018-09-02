//
//  StaffDetailTeamsTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "StaffDetailTeamsTableViewController.h"
#import "DoctorTeamTableViewCell.h"

@interface StaffDetailTeamsTableViewController ()
<TaskObserver>
{
    NSArray* teamItems;
    NSInteger staffUserId;
}


@end

@implementation StaffDetailTeamsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if (staff.userId)
    {
        staffUserId = staff.userId;
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.userId] forKey:@"userId"];
        
        [[TaskManager shareInstance] createTaskWithTaskName:@"StaffTeamsTask" taskParam:dicPost TaskObserver:self];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (teamItems) {
        return;
    }
    if (staffUserId > 0)
    {
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:[NSString stringWithFormat:@"%ld", staffUserId] forKey:@"userId"];
        
        [[TaskManager shareInstance] createTaskWithTaskName:@"StaffTeamsTask" taskParam:dicPost TaskObserver:self];
    }
    
}

- (void) setStaffUserId:(NSInteger)aStaffUserId
{
    staffUserId = aStaffUserId;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (teamItems)
    {
        return teamItems.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 0.5)];
    [footer setBackgroundColor:[UIColor commonBackgroundColor]];
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DoctorTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorTeamTableViewCell"];
    if (!cell)
    {
        cell = [[DoctorTeamTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DoctorTeamTableViewCell"];
    }
    // Configure the cell...
    TeamInfo* team = teamItems[indexPath.row];
    [cell setTeamInfo:team];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamInfo* team = teamItems[indexPath.row];
    //TeamDetailViewController
    [HMViewControllerManager createViewControllerWithControllerName:@"TeamDetailViewController" ControllerObject:team];
}

#pragma mark - TaskObserver

- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    //[self.tableView.mj_footer endRefreshing];
    if (StepError_None != taskError) {
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
    
    if (!taskname || 0 == taskname)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"StaffTeamsTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* teams = (NSArray*) taskResult;
            teamItems = [NSArray arrayWithArray:teams];
            [self.tableView reloadData];
        }
    }
}
@end
