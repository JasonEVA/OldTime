//
//  OrderDetailTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OrderDetailTableViewController.h"
#import "OrderInfo.h"
#import "OrderDetailTableViewCell.h"

#import "OrderUserServiceTableViewCell.h"
#import "OrderPaywayChooseTableViewController.h"
#import "WXApi.h"
#import "HMSecondEditionPayWayViewController.h"
@interface OrderDetailStartViewController ()
<TaskObserver>
{
    OrderDetailTableViewController* tvcDetail;
    OrderInfo* order;
    NSString* orderId;
}
@property (nonatomic, strong) HMSecondEditionPayWayViewController *payWayVC;
@end

@interface OrderDetailTableViewController ()
<TaskObserver>
{
    //id orderProduct;
    NSString* orderId;
}

@property (nonatomic, retain) OrderInfo* orderInfo;
@property (nonatomic, retain) id orderProduct;
@property (nonatomic) NSInteger requestCount;
@property (nonatomic, assign) NSInteger orderIntegral;

- (id) initWithOrderId:(NSString*) orderId;
@end

@implementation OrderDetailStartViewController

- (instancetype)initWithOrderId:(NSString *)orderIdString {
    if (self = [super init]) {
        [self.navigationItem setTitle:@"订单详情"];
        orderId = orderIdString;
        [self createOrderDetailTable];
    }
    return self;
}

- (void) dealloc
{
    if (tvcDetail)
    {
        [tvcDetail removeObserver:self forKeyPath:@"orderInfo"];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}



- (void) viewDidLoad
{
    [super viewDidLoad];
    // 禁用滑动返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationItem setTitle:@"订单详情"];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]])
    {
        //NSDictionary* dicObj = (NSDictionary*) self.paramObject;
        //order = [OrderInfo mj_objectWithKeyValues:dicObj];
        orderId = (NSString*)self.paramObject;
        [self createOrderDetailTable];
    }
    
}

- (void) createOrderDetailTable
{
    tvcDetail = [[OrderDetailTableViewController alloc]initWithOrderId:[NSString stringWithFormat:@"%ld", orderId.integerValue]];
    [self addChildViewController:tvcDetail];
    [tvcDetail.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tvcDetail.tableView];
    
    [tvcDetail addObserver:self forKeyPath:@"orderInfo" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"orderInfo"])
    {
        order = [object valueForKey:@"orderInfo"];
        if (0 == order.orderMoney)
        {
            //不显示付款
            if (self.payWayVC.view.superview) {
                [self.payWayVC.view removeFromSuperview];
            }
            [tvcDetail.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(self.view);
                make.top.equalTo(self.view);
                make.bottom.equalTo(self.view);
            }];

        }
        else
        {
            if (order.orderStatus == 1) {
                //显示付款
                [self requestForPayWayList];
                
            }
            else {
                //不显示付款
                if (self.payWayVC.view.superview) {
                    [self.payWayVC removeFromParentViewController];
                    [self.payWayVC.view removeFromSuperview];
                }
                [tvcDetail.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.equalTo(self.view);
                    make.top.equalTo(self.view);
                    make.bottom.equalTo(self.view);
                }];
            }
        }
    }
}
- (void)requestForPayWayList {
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"OrderPayWayListTask" taskParam:nil TaskObserver:self];
}

#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
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
    
    if ([taskname isEqualToString:@"OrderPayWayListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* payways = (NSArray*) taskResult;
            if (!self.payWayVC) {
                self.payWayVC = [[HMSecondEditionPayWayViewController alloc] initWithPayWayList:payways orderInfo:order];
                [self addChildViewController:self.payWayVC];
                [self.view addSubview:self.payWayVC.view];
                [self.payWayVC didMoveToParentViewController:self];
                
                [self.payWayVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@300);
                    make.left.right.bottom.equalTo(self.view);
                }];
                
                [tvcDetail.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.equalTo(self.view);
                    make.top.equalTo(self.view);
                    make.bottom.equalTo(self.payWayVC.view.mas_top);
                }];

            }
            
        }
    }
    
    
}



@end

typedef enum : NSUInteger {
    OrderDetail_OrderNameSection,
    OrderDetail_OrderNumSection,
    OrderDetail_OrderProductSection,
    OrderDetail_OrderAmountSection,
    orderDetail_OrderInfoSection,
    OrderDetail_OrderIntegalSection,    //获取的积分
    OrderDetailTableSectionCount,
} OrderDetailTableSection;

@implementation OrderDetailTableViewController

- (id) initWithOrderId:(NSString *) aOrderId
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        //orderInfo = order;
        orderId = aOrderId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorColor:[UIColor commonBackgroundColor]];
    [self.navigationItem setTitle:@"订单详情"];
    self.requestCount = 0;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (orderId)
    {
        [self requestForOrderDetail];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestForOrderDetail {
    self.requestCount ++;
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:orderId forKey:@"orderId"];
    [self.tableView.superview showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"OrderDetailTask" taskParam:dicPost TaskObserver:self];
}

- (void) requestForOrderIntegral
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:orderId forKey:@"orderId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"OrderIntegralTask" taskParam:dicPost TaskObserver:self];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return OrderDetailTableSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (!_orderInfo)
    {
        return 0;
    }
    switch (section)
    {
        case OrderDetail_OrderNameSection:
        case OrderDetail_OrderNumSection:
        
        case OrderDetail_OrderAmountSection:
        case orderDetail_OrderInfoSection:
        case OrderDetail_OrderIntegalSection:
            return 1;
            break;
        case OrderDetail_OrderProductSection:
        {
            if (_orderInfo.orderTypeCode)
            {
                if([_orderInfo.orderTypeCode isEqualToString:@"SERVICE"])
                {
                    return 1;
                }
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case OrderDetail_OrderNameSection:
        case OrderDetail_OrderNumSection:
            return 46;
            break;
        case OrderDetail_OrderProductSection:
        {
            return [self productcellHeight];
        }
            break;
        case OrderDetail_OrderAmountSection:
            return 40;
        case orderDetail_OrderInfoSection:
            return 79;
        case OrderDetail_OrderIntegalSection:
            return 45;
        default:
            break;
    }
    
    return 45;
}

- (CGFloat) productcellHeight
{
    if (_orderInfo)
    {
        if (_orderInfo.orderTypeCode && [_orderInfo.orderTypeCode isEqualToString:@"SERVICE"])
        {
            return 85;
        }
    }
    return 45;
}

- (CGFloat) footerHeight:(NSInteger) section
{
    switch (section)
    {
        case OrderDetail_OrderAmountSection:
        case orderDetail_OrderInfoSection:
            return 5;
            break;
            
        default:
            break;
    }
    return 0.5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self footerHeight:section];
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, [self footerHeight:section])];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    return footerview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case OrderDetail_OrderNameSection:
        {
            cell = [self orderNameCell];
        }
            break;
        case OrderDetail_OrderNumSection:
        {
            cell = [self orderNumCell];
        }
            break;
        case OrderDetail_OrderAmountSection:
        {
            cell = [self orderAmountCell];
        }
            break;
        case OrderDetail_OrderProductSection:
        {
            cell = [self productCell:indexPath.row];
        }
            break;
        case orderDetail_OrderInfoSection:
        {
            cell = [self orderInfoCell];
        }
            break;
        case OrderDetail_OrderIntegalSection:
        {
            cell = [self orderIntegalCell];
            break;
        }
        default:
            break;
    }
    
    // Configure the cell...
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderDetailTableViewCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


- (UITableViewCell*) orderNameCell
{
    OrderDetailNameTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"OrderDetailNameTableViewCell"];
    if (!cell)
    {
        cell = [[OrderDetailNameTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderDetailNameTableViewCell"];
    }
    if (_orderInfo)
    {
        [cell setOrderName:_orderInfo.orderName];
    }
    return cell;
}

- (UITableViewCell*) orderNumCell
{
    OrderDetailNumTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"OrderDetailNumTableViewCell"];
    if (!cell)
    {
        cell = [[OrderDetailNumTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderDetailNumTableViewCell"];
    }
    if (_orderInfo)
    {
        [cell setOrderNum:_orderInfo.orderNum];
    }
    return cell;
}

- (UITableViewCell*) orderAmountCell
{
    OrderDetailAmountTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"OrderDetailAmountTableViewCell"];
    if (!cell)
    {
        cell = [[OrderDetailAmountTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderDetailAmountTableViewCell"];
    }
    if (_orderInfo)
    {
        [cell setOrderAmount:_orderInfo.orderMoney];
    }
    return cell;
}

- (UITableViewCell*) orderIntegalCell
{
    OrderDetailIntegalTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"OrderDetailIntegalTableViewCell"];
    if (!cell) {
        cell = [[OrderDetailIntegalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderDetailIntegalTableViewCell"];
    }
    
    [cell setIntegal:self.orderIntegral];
    
    return cell;
}

- (UITableViewCell*) orderInfoCell
{
    OrderDetailTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"OrderDetailTableViewCell"];
    if (!cell)
    {
        cell = [[OrderDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderDetailTableViewCell"];
    }
    if (_orderInfo)
    {
        [cell setOrderInfo:_orderInfo];
    }
    return cell;
}

- (UITableViewCell*) productCell:(NSInteger) row
{
    if (_orderInfo && _orderInfo.orderTypeCode)
    {
        if ([_orderInfo.orderTypeCode isEqualToString:@"SERVICE"])
        {
            //用户服务信息
            OrderUserServiceTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"OrderUserServiceTableViewCell"];
            if (!cell)
            {
                cell = [[OrderUserServiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderUserServiceTableViewCell"];
            }
            if (_orderProduct && [_orderProduct isKindOfClass:[UserServiceInfo class]])
            {
                UserServiceInfo* userService = (UserServiceInfo*) _orderProduct;
                [cell setUserService:userService];
            }
            return cell;
        }
    }
    return nil;
}

#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
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
    
    if ([taskname isEqualToString:@"OrderDetailTask"])
    {
        if (self.requestCount < 2 && errorMessage && errorMessage.length) {
            [self.tableView.superview showWaitView];
            [self performSelector:@selector(requestForOrderDetail) withObject:nil afterDelay:3.0f];
        }
        else {
            if (!errorMessage || !errorMessage.length) {
                [self requestForOrderIntegral];
                return;
            }
            
            if (StepError_None != taskError)
            {
                [self showAlertMessage:errorMessage];
                return;
            }
            
        }

    }
    if ([taskname isEqualToString:@"OrderIntegralTask"])
    {
        [self.tableView reloadData];
    }
    
}

- (void) task:(NSString *)taskId Result:(id)taskResult
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
    
    if ([taskname isEqualToString:@"OrderDetailTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            //_orderInfo = [dicResult valueForKey:@"order"];
            [self setOrderInfo:[dicResult valueForKey:@"order"]];
            
            _orderProduct = [dicResult valueForKey:@"product"];
            if (_orderInfo && [_orderInfo isKindOfClass:[OrderInfo class]])
            {
                [self.tableView reloadData];
            }
        }
        
    }
    if ([taskname isEqualToString:@"OrderIntegralTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSNumber class]])
        {
            NSNumber* integralNumber = (NSNumber*) taskResult;
            self.orderIntegral = integralNumber.integerValue;
        }
    }
}
@end
