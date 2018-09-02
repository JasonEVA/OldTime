//
//  SearchServiceListTableViewController.m
//  HMClient
//
//  Created by yinquan on 16/12/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SearchServiceListTableViewController.h"
#import "ServiceInfo.h"
#import "ServiceInfoTableViewCell.h"
#import "ServiceGoodsInfoTableViewCell.h"

@interface SearchServiceListTableViewController ()
<TaskObserver,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSInteger totalCount;
    NSMutableArray* serviceList;
}
@property (nonatomic, readonly) ServiceSearchModel* serviceModel;

@end

@implementation SearchServiceListTableViewController

- (id) initWithSearchModel:(ServiceSearchModel*) serviceModel keyword:(NSString*) keyword
{
    self = [super init];
    if (self) {
        _serviceModel = serviceModel;
        _keyword = keyword;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadServiceList)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
    
}

- (void) setKeyword:(NSString *)keyword
{
    _keyword = keyword;
    if (serviceList) {
        [self.tableView setContentOffset:CGPointMake(0, 0)];
        [serviceList removeAllObjects];
        [self.tableView reloadData];
        
    }
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)  loadServiceList
{
    NSDictionary* dicPost = [NSMutableDictionary dictionary];
    
    if (self.serviceModel.productTypeId)
    {
        [dicPost setValue:[NSString stringWithFormat:@"%ld", (long)self.serviceModel.productTypeId] forKey:@"productTypeId"];
    }
    
    [dicPost setValue:self.keyword forKey:@"keyWord"];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:20] forKey:@"rows"];
//    if (serviceList && serviceList.count > 0)
//    {
//        [dicPost setValue:[NSNumber numberWithInteger:serviceList.count] forKey:@"rows"];
//    }
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceListTask" taskParam:dicPost TaskObserver:self];
}

- (void) loadMoreServiceList
{
    NSDictionary* dicPost = [NSMutableDictionary dictionary];
    
    if (self.serviceModel.productTypeId)
    {
        [dicPost setValue:[NSString stringWithFormat:@"%ld", self.serviceModel.productTypeId] forKey:@"productTypeId"];
    }
    
    [dicPost setValue:self.keyword forKey:@"keyWord"];
    [dicPost setValue:[NSNumber numberWithInteger:20] forKey:@"rows"];
    if (serviceList)
    {
        [dicPost setValue:[NSNumber numberWithInteger:serviceList.count] forKey:@"startRow"];
    }
    //ServiceListTask
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceListTask" taskParam:dicPost TaskObserver:self];
}

- (void) serviceListLoaded:(NSArray*) services
{
    serviceList = [NSMutableArray arrayWithArray:services];
    [self.tableView reloadData];
    
    if (serviceList.count >= totalCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreServiceList)];
    }
    
}

- (void) moreServiceListLoaded:(NSArray*) services
{
    if (!serviceList)
    {
        serviceList = [NSMutableArray array];
    }
    [serviceList addObjectsFromArray:services];
    [self.tableView reloadData];
    
    if (serviceList.count >= totalCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData ];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreServiceList)];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    if (serviceList)
    {
        return serviceList.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceInfo* service = serviceList[indexPath.row];
    BOOL isGoods = [service isGoods];
    if (isGoods) {
        return 110;
    }
    return 155;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (totalCount > 0) {
        return 45;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.tableHeaderView.width, tableView.tableHeaderView.height)];
    [headerView setBackgroundColor:[UIColor commonBackgroundColor]];
    
    UILabel *title = [[UILabel alloc] init];
    [headerView addSubview:title];
    
    [title setText:[NSString stringWithFormat:@"共搜索到 %ld 个结果",totalCount]];
    [title setTextColor:[UIColor commonGrayTextColor]];
    NSRange range = [title.text rangeOfString:[NSString stringWithFormat:@"%ld", totalCount]];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title.text];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range: range];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor commonRedColor] range:range];
    title.attributedText = attr;
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).with.offset(12);
        make.centerY.equalTo(headerView);
    }];
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceInfo* service = serviceList[indexPath.row];
    ServiceInfoTableViewCell *cell = nil;
    //TODO:判断是否是商品
    BOOL isGoods = [service isGoods];
    if (isGoods) {
        //商品Cell
        ServiceGoodsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceGoodsInfoTableViewCell"];
        if (!cell) {
            cell = [[ServiceGoodsInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceGoodsInfoTableViewCell"];
        }
        [cell setServiceGoodsInfo:service];
        return cell;
    }
    else
    {
        //套餐服务Cell
        cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceInfoTableViewCell" ];
        if (!cell)
        {
            cell = [[ServiceInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceInfoTableViewCell"];
        }
        if (service.grade && service.grade > 0)
        {
            [cell setServiceInfo:service isGrade:YES];
        }else{
            [cell setServiceInfo:service isGrade:NO];
        }
    }
    
    // Configure the cell...
    if (!cell) {
        cell = [[ServiceInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceInfoTableViewCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceInfo* service = serviceList[indexPath.row];
    ServiceInfo* serviceInfo = [[ServiceInfo alloc]init];
    [serviceInfo setUpId:service.upId];
    [serviceInfo setProductName:service.productName];
    [serviceInfo setClassify:service.classify];
    if (![service isGoods]) {
        //服务详情
//        [HMViewControllerManager createViewControllerWithControllerName:@"ServiceDetailStartViewController" ControllerObject:serviceInfo];
        [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceDetailViewController" ControllerObject:[NSString stringWithFormat:@"%ld", serviceInfo.upId]];
        
    }
    else
    {
        //商品详情
//        [HMViewControllerManager createViewControllerWithControllerName:@"ServiceGoodsDetailStartViewController" ControllerObject:serviceInfo];
        [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceDetailViewController" ControllerObject:[NSString stringWithFormat:@"%ld", serviceInfo.upId]];
    }
}


#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView.mj_header endRefreshing];
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
    
    if ([taskname isEqualToString:@"ServiceListTask"])
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
                [self moreServiceListLoaded:items];
                return;
            }
            else
            {
                [self serviceListLoaded:items];
            }
            
        }
        
    }
}

#pragma mark - DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"img_blank_list"];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!serviceList || serviceList.count == 0) {
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
    
    return -68 ;
}

@end
