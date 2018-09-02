//
//  AppointmentListTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppointmentListTableViewController.h"
#import "AppointmentInfoTableViewCell.h"
#import "AppointmentDetailImageTableViewCell.h"

@interface AppointmentListTableViewController ()
<TaskObserver>
{
   // NSInteger totalCount;
    NSMutableArray* appoints;
    NSString* selectStatus;
}
@end

#define kAppointmentPageSize        20


@implementation AppointmentListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setAppointStatus:(NSString*) status
{
    if (appoints)
    {
        [appoints removeAllObjects];
        [self.tableView reloadData];
    }
    selectStatus = status;
    //AppointmentListTask
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    NSInteger rows = kAppointmentPageSize;
    if (appoints && 0 < appoints.count)
    {
        rows = appoints.count;
    }
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    if (selectStatus)
    {
        [dicPost setValue:selectStatus forKey:@"status"];
    }
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"AppointmentListTask" taskParam:dicPost TaskObserver:self];
}

- (void) appointmentListLoaded:(NSArray*) items
{
    if (!appoints)
    {
        appoints = [NSMutableArray array];
    }
    
    [appoints addObjectsFromArray:items];
    [self.tableView reloadData];
    
    
    if (appoints.count < _totalCount)
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAppointmetns)];
    }
    else
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
}

- (void) loadMoreAppointmetns
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    NSInteger startRow = 0;
    if (appoints)
    {
        startRow = appoints.count;
    }
    [dicPost setValue:[NSNumber numberWithInteger:startRow] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kAppointmentPageSize] forKey:@"rows"];
    if (selectStatus)
    {
        [dicPost setValue:selectStatus forKey:@"status"];
    }
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"AppointmentListTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (appoints)
    {
        return appoints.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 177;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppointmentInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointmentInfoTableViewCell" ];
    if (!cell)
    {
        cell = [[AppointmentInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppointmentInfoTableViewCell"];
    }
    // Configure the cell...
    AppointmentInfo* appoint = appoints[indexPath.row];
    [cell setAppointmentInfo:appoint];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppointmentInfo* appoint = appoints[indexPath.row];
    //跳转到约诊详情界面 AppointmentDetailViewController
    [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentDetailViewController" ControllerObject:appoint];
}


#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
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
    
    NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
    if (dicParam && [dicParam isKindOfClass:[NSDictionary class]])
    {
        NSNumber* numStart = [dicParam valueForKey:@"startRow"];
        if (numStart && [numStart isKindOfClass:[NSNumber class]] && 0 == numStart.integerValue)
        {
            appoints = [NSMutableArray array];
        }
    }
    
    if ([taskname isEqualToString:@"AppointmentListTask"])
    {
        NSDictionary* dicResult = (NSDictionary*)taskResult;
        NSNumber* numCount = [dicResult valueForKey:@"count"];
        NSArray* list = [dicResult valueForKey:@"list"];
        
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            //totalCount = numCount.integerValue;
            [self setTotalCount:numCount.integerValue];
        }
        
        if (list && [list isKindOfClass:[NSArray class]])
        {
            [self appointmentListLoaded:list];
        }

    }
}


@end
