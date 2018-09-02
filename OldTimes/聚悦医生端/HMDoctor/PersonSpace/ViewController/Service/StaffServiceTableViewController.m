//
//  StaffServiceTableViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "StaffServiceTableViewController.h"
#import "ServiceInfoTableViewCell.h"
#import "ServiceRecordInfoTableViewCell.h"
#import "ServiceGoodsInfoTableViewCell.h"
#import "SecondEditionStaffServiceQRCodeViewController.h"
#import "HMBaseNavigationViewController.h"



@interface StaffServiceTableViewController ()
<TaskObserver>
{
    NSArray* services;
}
@end

@implementation StaffServiceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //StaffServiceListTask
    [self.tableView showWaitView];
    [self.tableView setScrollEnabled:NO];
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"StaffServiceListTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (services)
    {
        return services.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceInfo* service = services[indexPath.row];
    BOOL isGoods = [service isGoods];
    if (isGoods) {
        return 110;
    }
    return 154;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ServiceInfo* service = services[indexPath.row];
    ServiceInfoTableViewCell *cell = nil;
    
    BOOL isGoods = [service isGoods];
    if (isGoods) {
        //商品Cell
        ServiceGoodsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceGoodsInfoTableViewCell"];
        if (!cell) {
            cell = [[ServiceGoodsInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceGoodsInfoTableViewCell"];
        }
        [cell setServiceGoodsInfo:service];
        [cell.scanButton setTag:indexPath.row];
        [cell.scanButton addTarget:self action:@selector(scanerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }
    else{
        //套餐服务Cell
        cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceInfoTableViewCell"];
        if (!cell)
        {
            cell = [[ServiceInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceInfoTableViewCell"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        if (service.grade && service.grade > 0)
        {
            [cell setServiceInfo:service isGrade:YES];
        }else{
            [cell setServiceInfo:service isGrade:NO];
        }
        [cell.scanButton setTag:indexPath.row];
        [cell.scanButton addTarget:self action:@selector(scanerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    // Configure the cell...
    if (!cell) {
        cell = [[ServiceInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceInfoTableViewCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

- (void)scanerButtonClick:(UIButton *)sender
{
    ServiceInfo* service = services[sender.tag];
//    [HMViewControllerManager createViewControllerWithControllerName:@"StaffServiceQRCodeViewController" ControllerObject:service];
    
    SecondEditionStaffServiceQRCodeViewController* qrCodevViewController = [[SecondEditionStaffServiceQRCodeViewController alloc] initWithServiceInfo:service];
    HMBaseNavigationViewController* navigationViewController = [[HMBaseNavigationViewController alloc] initWithRootViewController:qrCodevViewController];
    [self presentViewController:navigationViewController animated:YES completion:nil];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //ServiceDetailViewController
    ServiceInfo* service = services[indexPath.row];
    
    [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceDetailViewController" ControllerObject:service];
    
    /*
    if (![service isGoods]) {
        //服务详情
        [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceDetailViewController" ControllerObject:service];
    }
    else{
    
        //商品详情
        [HMViewControllerManager createViewControllerWithControllerName:@"ServiceGoodsDetailViewController" ControllerObject:service];
    }
    */
}

#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView closeWaitView];
    [self.tableView setScrollEnabled:YES];
    
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
    }
    
    if (!services || 0 == services.count)
    {
        [self showBlankView];
    }
    [self.tableView reloadData];
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
    
    if (taskResult && [taskResult isKindOfClass:[NSArray class]])
    {
        services = (NSArray*) taskResult;
    }
}
@end

@interface StaffServiceHistoryTableViewController ()
<TaskObserver>
{
    NSInteger totalCount;
    NSMutableArray* services;
}
@end

#define kServiceHistoryPageSize         20

@implementation StaffServiceHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //StaffServiceListTask
    [self.tableView showWaitView];
    [self.tableView setScrollEnabled:NO];
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kServiceHistoryPageSize] forKey:@"rows"];
    
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"StaffServiceHistoryListTask" taskParam:dicPost TaskObserver:self];
}

- (void) loadMoreServiceHistory
{
    NSInteger startRow = 0;
    if (services)
    {
        startRow = services.count;
    }
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSNumber numberWithInteger:startRow] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kServiceHistoryPageSize] forKey:@"rows"];
    
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"StaffServiceHistoryListTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    if (services)
    {
        return services.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceRecordInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceRecordInfoTableViewCell"];
    if (!cell)
    {
        cell = [[ServiceRecordInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceRecordInfoTableViewCell"];
    }
    // Configure the cell...
    ServiceRecordInfo* service = services[indexPath.row];
    [cell setServiceRecord:service];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}



#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView closeWaitView];
    [self.tableView setScrollEnabled:YES];
    
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
    }
    
    [self.tableView reloadData];
    if (!services || 0 == services.count)
    {
        [self showBlankView];
    }
    
    
    if (services.count >= totalCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData ];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreServiceHistory)];
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
    
    if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResult = (NSDictionary*) taskResult;
        
        NSNumber* numCount = [dicResult valueForKey:@"count"];
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            totalCount = numCount.integerValue;
        }
        
        NSArray *items = [dicResult valueForKey:@"list"];
        if (!services) {
            services = [NSMutableArray array];
        }
        [services addObjectsFromArray:items];
    }
}
@end
