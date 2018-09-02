//
//  AddedValueServiceListViewController.m
//  HMClient
//
//  Created by yinquan on 17/3/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "AddedValueServiceListViewController.h"
#import "ServiceInfoTableViewCell.h"
#import "ServiceGoodsInfoTableViewCell.h"


@interface AddedValueServiceListTableViewController : UITableViewController
<TaskObserver,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSMutableArray* serviceModels;
    NSInteger totalCount;
    
}
@property (nonatomic, readonly) NSString* classify;

- (id) initWithClassify:(NSString*) classify;
@end

@interface AddedValueServiceListViewController ()
{
    UITableViewController* serviceListTableViewController;
}
@end

@implementation AddedValueServiceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"增值服务"];
    serviceListTableViewController = [[AddedValueServiceListTableViewController alloc] initWithClassify:@"5"];
    [self addChildViewController:serviceListTableViewController];
    [self.view addSubview:serviceListTableViewController.tableView];
    [serviceListTableViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.bottom.equalTo(self.view);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

static const NSInteger kServiceListPageSize = 20;

@implementation AddedValueServiceListTableViewController

- (id) initWithClassify:(NSString*) classify
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _classify = classify;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadServiceList)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];

}


- (void)  loadServiceList
{
    NSDictionary* dicPost = [NSMutableDictionary dictionary];

    if (self.classify) {
        [dicPost setValue:self.classify forKey:@"classify"];
    }
    
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    NSInteger rows = kServiceListPageSize;
    if (serviceModels && serviceModels.count > 0)
    {
        rows = serviceModels.count;
    }
    
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"AddedValueServiceListTask" taskParam:dicPost TaskObserver:self];
}

- (void) loadMoreServiceList
{
    NSDictionary* dicPost = [NSMutableDictionary dictionary];
    
    if (self.classify) {
        [dicPost setValue:self.classify forKey:@"classify"];
    }
    
    [dicPost setValue:[NSNumber numberWithInteger:serviceModels.count] forKey:@"startRow"];
    NSInteger rows = kServiceListPageSize;
    
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"AddedValueServiceListTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    if (serviceModels)
    {
        return serviceModels.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceInfo* service = serviceModels[indexPath.row];
    BOOL isGoods = [service isGoods];
    if (isGoods) {
        return 110;
    }
    return 155;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceInfo* service = serviceModels[indexPath.row];
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
    ServiceInfo* service = serviceModels[indexPath.row];
    ServiceInfo* serviceInfo = [[ServiceInfo alloc]init];
    [serviceInfo setUpId:service.upId];
    [serviceInfo setProductName:service.productName];
    [serviceInfo setClassify:service.classify];
    if (![service isGoods]) {
        //服务详情
        
        //SecondEditionServiceDetailViewController
        [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceDetailViewController" ControllerObject:[NSString stringWithFormat:@"%ld", serviceInfo.upId]];
        
    }
    else
    {
        //商品详情
        [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceDetailViewController" ControllerObject:[NSString stringWithFormat:@"%ld", serviceInfo.upId]];
    }
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView.mj_header endRefreshing];
    if (self.tableView.mj_footer)
    {
        [self.tableView.mj_footer endRefreshing];
    }
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    if ([taskname isEqualToString:@"AddedValueServiceListTask"])
    {
        if (serviceModels && serviceModels.count < totalCount) {
            self.tableView.mj_footer = self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreServiceList)];
        }
        else
        {
            if (self.tableView.mj_footer)
            {
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
    if ([taskname isEqualToString:@"AddedValueServiceListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* respDict = (NSDictionary*) taskResult;
            NSNumber* countNumber = [respDict valueForKey:@"count"];
            NSArray* list = [respDict valueForKey:@"list"];
            if (countNumber)
            {
                totalCount = countNumber.integerValue;
            }
            NSDictionary* paramDict = [TaskManager taskparamWithTaskId:taskId];
            NSInteger startRow = 0;
            NSNumber* startRowsNum = [paramDict valueForKey:@"startRow"];
            if (startRowsNum) {
                startRow = startRowsNum.integerValue;
            }
            
            if (0 == startRow)
            {
                serviceModels = [NSMutableArray arrayWithArray:list];
            }
            else
            {
                if (!serviceModels) {
                    serviceModels = [NSMutableArray arrayWithArray:list];
                }
                else
                {
                    [serviceModels addObjectsFromArray:list];
                }
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
    
    if (!serviceModels ||serviceModels.count == 0) {
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
