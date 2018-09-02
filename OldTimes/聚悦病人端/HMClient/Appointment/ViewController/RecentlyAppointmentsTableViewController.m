//
//  RecentlyAppointmentsTableViewController.m
//  HMClient
//
//  Created by yinquan on 2017/10/18.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "RecentlyAppointmentsTableViewController.h"
#import "RecentlyAppointmentTableViewCell.h"

@interface RecentlyAppointmentsTableViewController ()
<TaskObserver>
{
    NSArray* recentlyAppointments;
}
@end

@implementation RecentlyAppointmentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadResentAppointmentList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadResentAppointmentList{
    //ResentAppointmentListTask
    [[TaskManager shareInstance] createTaskWithTaskName:@"ResentAppointmentListTask" taskParam:nil TaskObserver:self];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (recentlyAppointments) {
        return recentlyAppointments.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecentlyAppointmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentlyAppointmentTableViewCell"];
    if (!cell) {
        cell = [[RecentlyAppointmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecentlyAppointmentTableViewCell"];
    }
    // Configure the cell...
    
    RecentlyAppointmentModel* model = recentlyAppointments[indexPath.row];
    [cell setRecentlyAppointmentModel:model];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark - UITableView delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (taskError != StepError_None) {
        [self showAlertMessage:errorMessage];
        return;
    }
    [self.tableView reloadData];
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
    if ([taskname isEqualToString:@"ResentAppointmentListTask"]) {
        if(taskResult && [taskResult isKindOfClass:[NSArray class]]){
            recentlyAppointments = taskResult;
        }
    }
    
}

@end
