//
//  OrderedServiceListTableViewController.m
//  HMClient
//  我的当前服务列表
//  Created by yinquan on 16/11/14.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OrderedServiceListTableViewController.h"
#import "OrderedServiceModel.h"
#import "OrderedServiceTableViewCell.h"

@interface OrderedServiceListTableViewController ()
<TaskObserver,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, readonly) NSDictionary* dicServices;
@property (nonatomic, readonly) OrderedServiceModel* packageServie;
@property (nonatomic, readonly) NSArray* appreciationServices;
@property (nonatomic, copy) isHaveService block;
@end

typedef NS_ENUM(NSUInteger, EOrderedServiceTableSection) {
    OrderService_Section,
    AppreciationServices_Section,
    OrderedServiceTableSectionCount,
};

@implementation OrderedServiceListTableViewController

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
    [self checkServiceStatus];
}

// 检查是否有服务
- (void)checkServiceStatus {
    [self.tableView.superview showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"PersonServiceSummaryTask" taskParam:nil TaskObserver:self];
}

- (void) loadServiceList
{
    [self.tableView.superview showWaitView];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:@[@"2",@"6"] forKey:@"status"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"OrderServiceListTask" taskParam:dicPost TaskObserver:self];
}

- (void) serviceListLoaded:(NSDictionary*) dicService
{
    _dicServices = dicService;
    _packageServie = [dicService valueForKey:@"packageServie"];
    _appreciationServices = [dicService valueForKey:@"appreciationService"];
    [self.tableView reloadData];
}

- (void) moreServiceButtonClicked:(id) sender
{
    //跳转到服务分类列表页面
    [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceStartViewController" ControllerObject:nil];
}

- (void)acquireServiceStatus:(isHaveService)isHave {
    self.block = isHave;
}
#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return OrderedServiceTableSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    switch (section)
    {
        case OrderService_Section:
        {
            if (self.packageServie) {
                return 1;
            }
            break;
        }
        case AppreciationServices_Section:
        {
            if (self.appreciationServices) {
                return self.appreciationServices.count;
            }
        }
            
    }
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case OrderService_Section:
        {
            return [self.packageServie tableCellHeight];
            break;
        }
        case AppreciationServices_Section:
        {
            OrderedServiceModel* serviceModel = self.appreciationServices[indexPath.row];
            if ([serviceModel isGoods])
            {
                return 54 * kScreenWidthScale;
            }
            return 89 * kScreenWidthScale;
        }
        default:
            break;
    }
    return 47;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case OrderService_Section:
        {
            if (!self.packageServie) {
                return 0;
            }
            return 5;
        }
        case AppreciationServices_Section:
        {
            if (self.appreciationServices && self.appreciationServices.count)
            {
                return 45;
            }
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case OrderService_Section:
        {
            if (!self.packageServie) {
                return 0;
            }
            return 5;
        }
        case AppreciationServices_Section:
        {
            return 0.5;
        }
    }
    return 0;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    switch (section) {
        case OrderService_Section:
        {
            UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
            [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
            return footerview;
        }
        case AppreciationServices_Section:
        {
            UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
            [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
            return footerview;
        }
    }
    return nil;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case OrderService_Section:
        {
            UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
            [headerview setBackgroundColor:[UIColor commonBackgroundColor]];
            return headerview;
        }
        case AppreciationServices_Section:
        {
            if (self.appreciationServices && self.appreciationServices.count)
            {
                UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
                [headerview setBackgroundColor:[UIColor whiteColor]];
                
                UILabel* titleLable = [[UILabel alloc] init];
                [headerview addSubview:titleLable];
                [titleLable setFont:[UIFont font_30]];
                [titleLable setTextColor:[UIColor mainThemeColor]];
                [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(headerview).with.offset(12.5);
                    make.centerY.equalTo(headerview);
                }];
                [titleLable setText:@"增值服务"];
                [headerview showBottomLine];
                
                //更多增值服务
                UIButton* moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [headerview addSubview:moreButton];
                [moreButton setTitle:@"更多增值服务>" forState:UIControlStateNormal];
                [moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [moreButton.titleLabel setFont:[UIFont font_26]];
                [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(headerview).with.offset(-12.5);
                    make.centerY.equalTo(headerview);
                }];
                
                [moreButton addTarget:self action:@selector(moreServiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                return headerview;
            }
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    switch (indexPath.section) {
        case OrderService_Section:
        {
            OrderedServiceTableViewCell* packageCell = [tableView dequeueReusableCellWithIdentifier:@"OrderedServiceTableViewCell"];
            if (!packageCell) {
                packageCell = [[OrderedServiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderedServiceTableViewCell"];
            }
            [packageCell setOrderedService:self.packageServie];
            cell = packageCell;
            
        }
            break;
        case AppreciationServices_Section:
        {
            OrderedServiceModel* orderedService = self.appreciationServices[indexPath.row];
            if ([orderedService isGoods])
            {
                OrderedAppreciationGoodsTableViewCell* appreciationCell = [tableView dequeueReusableCellWithIdentifier:@"OrderedAppreciationGoodsTableViewCell"];
                if (!appreciationCell) {
                    appreciationCell = [[OrderedAppreciationGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderedAppreciationGoodsTableViewCell"];
                }
                [appreciationCell setOrderedService:self.appreciationServices[indexPath.row]];
                cell = appreciationCell;
            }
            else
            {
                OrderedAppreciationServiceTableViewCell* appreciationCell = [tableView dequeueReusableCellWithIdentifier:@"OrderedAppreciationServiceTableViewCell"];
                if (!appreciationCell) {
                    appreciationCell = [[OrderedAppreciationServiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderedAppreciationServiceTableViewCell"];
                }
                [appreciationCell setOrderedService:self.appreciationServices[indexPath.row]];
                cell = appreciationCell;
            }
            
            break;
        }
        default:
            break;
    }
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderedServiceListTableViewCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case OrderService_Section:
        {
            return;
        }
            break;
        case AppreciationServices_Section:
        {
            OrderedServiceModel* orderedService = self.appreciationServices[indexPath.row];
            
            if (orderedService.classify != 5) {
                return;
            }
            UserServiceDet* serviceDet = [orderedService.dets firstObject];
            if (!serviceDet) {
                return;
            }
            //跳转到服务详情 OrderedServiceDetDetailViewController
            [HMViewControllerManager createViewControllerWithControllerName:@"OrderedServiceDetDetailViewController" ControllerObject:serviceDet];
            break;
        }
        
    }
    
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (StepError_None != taskError)
    {
        [self.tableView.superview closeWaitView];

        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    [self.tableView.superview closeWaitView];

    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    if ([taskname isEqualToString:@"OrderServiceListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            [self serviceListLoaded:taskResult];
        }
    }
    else if([taskname isEqualToString:@"PersonServiceSummaryTask"]) {
        NSDictionary *dicService = (NSDictionary*)taskResult;
        //如果productName为空，是增值服务
        NSString* productName = [dicService objectForKey:@"productName"];
        NSArray* serviceDetsItems = [dicService valueForKey:@"serviceDets"];
        if (!serviceDetsItems || serviceDetsItems.count == 0) {
            //没有服务
            return;
        }
        else if (!productName || productName.length == 0) {
            // 只有增值服务
        }
        else
        {
            //有套餐服务
        }
        if (self.block) {
            self.block(YES);
        }

        [self loadServiceList];

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
    
    if (!self.packageServie || !self.appreciationServices ||self.appreciationServices.count == 0) {
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
