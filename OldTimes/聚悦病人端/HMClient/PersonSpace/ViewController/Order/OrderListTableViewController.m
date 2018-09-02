//
//  OrderListTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OrderListTableViewController.h"
#import "HMSwitchView.h"
#import "OrderListTableViewCell.h"

@interface OrderListStartViewController ()
<HMSwitchViewDelegate>
{
    HMSwitchView* orderSwitchview;
    OrderListTableViewController* tvcOrderList;
}
@end

@interface OrderListTableViewController ()
<TaskObserver>
{
    NSInteger totalCount;
    NSArray* status;
    NSMutableArray* orders;
}

- (void) setOrderStatus:(NSArray*) statusList;
@end

@implementation OrderListStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的订单"];
    
    [self createOrderSwitchView];
    [self createOrderTable];
}

- (void) createOrderSwitchView
{
    orderSwitchview = [[HMSwitchView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 47)];
    [self.view addSubview:orderSwitchview];
    [orderSwitchview createCells:@[@"全部", @"待支付"]];
    
    [orderSwitchview setDelegate:self];
}

- (void) createOrderTable
{
    tvcOrderList = [[OrderListTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcOrderList];
    [tvcOrderList.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tvcOrderList.tableView];
    [tvcOrderList.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(orderSwitchview.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    //[tvcOrderList setOrderStatus:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"A"]];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadOrders];
}

- (void) loadOrders
{
    switch (orderSwitchview.selectedIndex)
    {
        case 0:
        {
            [tvcOrderList setOrderStatus:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"A"]];
        }
            break;
        case 1:
        {
            //待付款
            [tvcOrderList setOrderStatus:@[@"1"]];
        }
            break;
        default:
            break;
    }

}

#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSInteger) selectedIndex
{
    if (switchview == orderSwitchview)
    {
        switch (selectedIndex)
        {
            case 0:
            {
                [tvcOrderList setOrderStatus:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"A"]];
            }
                break;
            case 1:
            {
                //待付款
                [tvcOrderList setOrderStatus:@[@"1"]];
            }
                break;
            default:
                break;
        }
    }
}

@end

#define kOrderListPageSize          20



@implementation OrderListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setOrderStatus:(NSArray*) statusList
{
    status = statusList;
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:status forKey:@"status"];
    [dicPost setValue:[NSNumber numberWithInteger:kOrderListPageSize] forKey:@"rows"];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    if (orders)
    {
        [orders removeAllObjects];
    }
    orders = [NSMutableArray array];
    [self.tableView reloadData];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"OrderListTask" taskParam:dicPost TaskObserver:self];
}

- (void) orderListLoaded:(NSArray*) items
{
    orders = [NSMutableArray arrayWithArray:items];
    [self.tableView reloadData];
    
    if (orders.count >= totalCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData ];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreOrderList)];
    }

}

- (void) moreOrderListLoaded:(NSArray*) items
{
    if (!orders)
    {
        orders = [NSMutableArray array];
    }
    [orders addObjectsFromArray:items];
    [self.tableView reloadData];
    
    if (orders.count >= totalCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData ];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreOrderList)];
    }
}

- (void) loadMoreOrderList
{
    NSDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:status forKey:@"status"];
    if (orders)
    {
        [dicPost setValue:[NSNumber numberWithInteger:orders.count] forKey:@"startRow"];
    }
    //ServiceListTask
    [dicPost setValue:[NSNumber numberWithInteger:kOrderListPageSize] forKey:@"rows"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"OrderListTask" taskParam:dicPost TaskObserver:self];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 0.5)];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    return footerview;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (orders)
    {
        return orders.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListTableViewCell" ];
    if (!cell)
    {
        cell = [[OrderListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderListTableViewCell"];
    }
    
    // Configure the cell...
    OrderInfo* order = orders[indexPath.row];
    [cell setOrderInfo:order];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderInfo* order = orders[indexPath.row];
    //跳转到订单详情 
    [HMViewControllerManager createViewControllerWithControllerName:@"OrderDetailStartViewController" ControllerObject:[NSString stringWithFormat:@"%ld", order.orderId]];
}
#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
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
    
    if ([taskname isEqualToString:@"OrderListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            NSNumber* numCount = [dicResult valueForKey:@"count"];
            if (numCount && [numCount isKindOfClass:[NSNumber class]]) {
                totalCount = numCount.integerValue;
            }
            
            NSArray* items = (NSArray*) [dicResult valueForKey:@"list"];
            
            NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
            NSNumber* numStart = [dicParam valueForKey:@"startRow"];
            if (numStart && [numStart isKindOfClass:[NSNumber class]] && 0 < numStart.integerValue)
            {
                //加载更多。。。
                [self moreOrderListLoaded:items];
                return;
            }
            else
            {
                [self orderListLoaded:items];
            }
            
        }
    }
}


@end
