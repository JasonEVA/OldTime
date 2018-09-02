//
//  OrderedHistoryServicesTableViewController.m
//  HMClient
//  我的订购历史列表
//  Created by yinquan on 16/11/14.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OrderedHistoryServicesTableViewController.h"
#import "OrderedServiceTableViewCell.h"

static const NSInteger kServiceListPageSize = 20;

@interface OrderedHistoryServicesTableViewController ()
<TaskObserver, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSInteger totalCount;
}
@property (nonatomic, readonly) NSMutableArray* serviceList;
@end

@implementation OrderedHistoryServicesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorInset = UIEdgeInsetsMake(0,0, 0, 0);
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadServiceList];
}

- (void) loadServiceList
{
    [self.tableView.superview showWaitView];
//    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
//    [dicPost setValue:@[@"2"] forKey:@"status"];
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:@0 forKey:@"startRow"];
    NSInteger rows = kServiceListPageSize;
    if (_serviceList && _serviceList.count > kServiceListPageSize) {
        rows = _serviceList.count;
    }
    [paramDict setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"OrderServiceHistoryListTask" taskParam:paramDict TaskObserver:self];
}

- (void) loadMoreServiceList
{
    if (!self.serviceList) {
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:[NSNumber numberWithInteger:self.serviceList.count]  forKey:@"startRow"];
    NSInteger rows = kServiceListPageSize;
        [paramDict setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"OrderServiceHistoryListTask" taskParam:paramDict TaskObserver:self];
}

- (void) serviceListLoaded:(NSArray*) serviceList
{
    _serviceList = [NSMutableArray arrayWithArray:serviceList];
}

- (void) moreServiceListLoaded:(NSArray*) serviceList
{
    if (!_serviceList) {
        _serviceList = [NSMutableArray arrayWithArray:serviceList];
    }
    else
    {
        [_serviceList addObjectsFromArray:serviceList];
    }

}



#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (self.serviceList) {
        return self.serviceList.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    
    return footerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderedServiceModel* orderedService = self.serviceList[indexPath.row];
    if (orderedService.classify != 5) {
        return [orderedService tableCellHeight] + 5;
    }
    else
    {
        if ([orderedService isGoods]) {
            return 54 * kScreenWidthScale + 5;
        }
        return 89 * kScreenWidthScale + 5;
    }
    return 47;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    OrderedServiceModel* orderedService = self.serviceList[indexPath.row];
    if (orderedService.classify != 5)
    {
        OrderedHistoryServiceTableViewCell* packageCell = [tableView dequeueReusableCellWithIdentifier:@"OrderedHistoryServiceTableViewCell"];
        if (!packageCell) {
            packageCell = [[OrderedHistoryServiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderedHistoryServiceTableViewCell"];
        }
        [packageCell setOrderedService:orderedService];
        cell = packageCell;
    }
    else
    {
        if ([orderedService isGoods])
        {
            OrderedHistoryAppreciationGoodsTableViewCell* appreciationCell = [tableView dequeueReusableCellWithIdentifier:@"OrderedHistoryAppreciationGoodsTableViewCell"];
            if (!appreciationCell) {
                appreciationCell = [[OrderedHistoryAppreciationGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderedHistoryAppreciationGoodsTableViewCell"];
            }
            [appreciationCell setOrderedService:orderedService];
            cell = appreciationCell;
        }
        else
        {
            OrderedAppreciationServiceTableViewCell* appreciationCell = [tableView dequeueReusableCellWithIdentifier:@"OrderedHistoryAppreciationServiceTableViewCell"];
            if (!appreciationCell) {
                appreciationCell = [[OrderedHistoryAppreciationServiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderedHistoryAppreciationServiceTableViewCell"];
            }
            [appreciationCell setOrderedService:orderedService];
            cell = appreciationCell;
        }
        
    }
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderedServiceListTableViewCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderedServiceModel* orderedService = self.serviceList[indexPath.row];
    
    if (orderedService.classify != 5) {
        return;
    }
    UserServiceDet* serviceDet = [orderedService.dets firstObject];
    if (!serviceDet) {
        return;
    }
    //跳转到服务详情 OrderedServiceDetDetailViewController
    [HMViewControllerManager createViewControllerWithControllerName:@"OrderedServiceDetDetailViewController" ControllerObject:serviceDet];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.tableView.superview closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    if (self.serviceList)
    {
        if (self.serviceList.count < totalCount) {
            if (self.tableView.mj_footer) {
                [self.tableView.mj_footer endRefreshing];
            }
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreServiceList)];
        }
        else
        {
            if (self.tableView.mj_footer) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }
        
        [self.tableView reloadData];
    }
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
    if ([taskname isEqualToString:@"OrderServiceHistoryListTask"])
    {
        if (!taskResult || ![taskResult isKindOfClass:[NSDictionary class]])
        {
            return;
        }
        NSDictionary* resultDict = (NSDictionary*) taskResult;
        NSNumber* countNumber = [resultDict valueForKey:@"count"];
        NSArray* serviceItems = [resultDict valueForKey:@"list"];
        if (countNumber && countNumber.integerValue > 0) {
            totalCount = countNumber.integerValue;
        }
        NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
        if (!dicParam)
        {
            [self serviceListLoaded:serviceItems];
            return;
        }
    
        NSNumber* startRowNumber = [dicParam valueForKey:@"startRow"];
        if (!startRowNumber || startRowNumber.integerValue == 0)
        {
            [self serviceListLoaded:serviceItems];
            return;
        }
        else
        {
            [self moreServiceListLoaded:serviceItems];
        }
    }
}

#pragma mark - DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"您还没有订购服务哦" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"666666"]}];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"emptyImage_e"];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return [[NSAttributedString alloc] initWithString:@"订购服务" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor mainThemeColor]}];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    //跳转到服务分类
    [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceStartViewController" ControllerObject:nil];
}


- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!self.serviceList ||self.serviceList.count == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -68;
}

@end
