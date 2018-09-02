//
//  ServiceGoodsDetailStartViewController.m
//  HMClient
//
//  Created by yinquan on 16/11/11.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceGoodsDetailStartViewController.h"
#import "ServiceInfo.h"
#import "ServiceDetailTableViewController.h"
#import "ServiceDetailTableViewCell.h"
#import "ServiceNeedMessageViewController.h"
#import "ServiceOrder.h"
#import "ServiceOrderConfrimTableViewController.h"
#import "HMSecondEditionServiceOrderConfrimViewController.h"

@interface ServiceGoodsDetailTableViewController : UITableViewController
<TaskObserver>
{
    ServiceDetailTableHeaderView* tableheaderview;
}
@property (nonatomic, readonly) NSInteger upId;
@property (nonatomic, readonly) ServiceDetail* serviceDetail;
@property (nonatomic, assign) NSInteger aService_status;
- (id) initWithServiceUpID:(NSInteger) aUpId;
- (NSArray*) serviceProductIDList;
@end


@interface ServiceGoodsDetailStartViewController ()
<TaskObserver>
{
    ServiceInfo* serviceInfo;
    ServiceGoodsDetailTableViewController* goodsTableViewController;
    UIButton* purchasebutton;
    
    ServiceOrder* serviceOrder;
}
@property (nonatomic, assign) NSInteger service_status;
@end



@implementation ServiceGoodsDetailStartViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:@"service_status"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"商品详情"];
    if (self.paramObject && [self.paramObject isKindOfClass:[ServiceInfo class]])
    {
        //NSDictionary* dicParam = (NSDictionary*) self.paramObject;
        //serviceInfo = [ServiceInfo mj_objectWithKeyValues:dicParam];
        serviceInfo = (ServiceInfo*)self.paramObject;
        if (serviceInfo.productName)
        {
            [self.navigationItem setTitle:serviceInfo.productName];
        }
    }

    purchasebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:purchasebutton];
    [purchasebutton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 40) Color:[UIColor mainThemeColor]]  forState:UIControlStateNormal];
    //[purchasebutton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 40) Color:[UIColor commonLightGrayTextColor]] forState:UIControlStateDisabled];
    [purchasebutton setTitle:@"立即购买" forState:UIControlStateNormal];
    [purchasebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [purchasebutton.titleLabel setFont:[UIFont font_30]];
    [purchasebutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.view);
    }];
    
    [purchasebutton addTarget:self action:@selector(purchasebuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self createDetailTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchasebuttonStatus:) name:@"service_status" object:nil];
}

- (void) purchasebuttonStatus:(NSNotification*)noti
{
    NSDictionary *nameDic = [noti userInfo];
    NSInteger status = [[nameDic objectForKey:@"service_status"] integerValue];
    
    switch (status)
    {
        case 0:
        {
            //可订购服务
            [purchasebutton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 40) Color:[UIColor mainThemeColor]]  forState:UIControlStateNormal];
        }
            break;
            
        case 1:
        {
            //已订购
            [purchasebutton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 40) Color:[UIColor commonLightGrayTextColor]] forState:UIControlStateNormal];
        }
            break;
            
        case 2:
        {
            //库存不足，不可订购
            [purchasebutton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 40) Color:[UIColor commonLightGrayTextColor]] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createDetailTable
{
    goodsTableViewController = [[ServiceGoodsDetailTableViewController alloc]initWithServiceUpID:serviceInfo.upId];
    [self addChildViewController:goodsTableViewController];
    [self.view addSubview:goodsTableViewController.tableView];
    
    [goodsTableViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(purchasebutton.mas_top);
    }];
}

- (void) purchasebuttonClicked:(id) sender
{
//    if (goodsTableViewController.serviceDetail.service_status == 1 || goodsTableViewController.serviceDetail.service_status == 2)
//    {
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:goodsTableViewController.serviceDetail.alert_msg delegate:nil cancelButtonTitle:@"我知道了！" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
//    
    //获取服务必填项
    NSArray* idList = [goodsTableViewController  serviceProductIDList];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:idList forKey:@"productIds"];
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceNeedMsgsTask" taskParam:nil TaskObserver:self];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"CreateServiceOrderTask"])
    {
        //跳转到订单详情页面
        if (serviceOrder)
        {
            [HMViewControllerManager createViewControllerWithControllerName:@"OrderDetailStartViewController" ControllerObject:[NSString stringWithFormat:@"%ld", serviceOrder.orderId]];
        }
        
        //刷新用户服务
        [[TaskManager shareInstance] createTaskWithTaskName:@"CheckUserServiceTask" taskParam:nil TaskObserver:self];
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
    
    if ([taskname isEqualToString:@"ServiceNeedMsgsTask"])
    {
        
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* needMsgs = (NSArray*) taskResult;
            if (needMsgs && 0 < needMsgs.count)
            {
                //需要填写服务必备信息
                ServiceNeedMessageViewController* vcNeedMsg = (ServiceNeedMessageViewController*)[HMViewControllerManager createViewControllerWithControllerName:@"ServiceNeedMessageViewController" ControllerObject:needMsgs];
                [vcNeedMsg setServiceDetail:goodsTableViewController.serviceDetail];
            }
            else
            {
                //不需要填写服务必备信息
                if (0 == goodsTableViewController.serviceDetail.salePrice)
                {
                    //免费服务，不需要跳转到订单确认页面
                    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
                    [dicPost setValue:[NSNumber numberWithInteger:goodsTableViewController.serviceDetail.UP_ID]  forKey:@"upId"];
                    [dicPost setValue:@"SERVICE" forKey:@"orderTypeCode"];
                    [dicPost setValue:@"IOS" forKey:@"sourceCode"];
                    NSMutableArray* options = [NSMutableArray array];
                    
                    if (goodsTableViewController.serviceDetail.isMustYes)
                    {
                        for (ServiceDetailOption* option in goodsTableViewController.serviceDetail.isMustYes)
                        {
                            NSDictionary* dicOption = [option mj_keyValues];
                            [options addObject:dicOption];
                        }
                    }
                    if (goodsTableViewController.serviceDetail.selectMust)
                    {
                        for (ServiceDetailOption* option in goodsTableViewController.serviceDetail.selectMust)
                        {
                            NSDictionary* dicOption = [option mj_keyValues];
                            [options addObject:dicOption];
                        }
                    }
                    
                    if (0 < options.count) {
                        [dicPost setValue:options forKey:@"orderBusinessDets"];
                    }
                    
                    [self.view showWaitView];
                    //直接创建订单
                    [[TaskManager shareInstance] createTaskWithTaskName:@"CreateServiceOrderTask" taskParam:dicPost TaskObserver:self];
                    return;
                }
            }
        }
        else
        {
            if (0 == goodsTableViewController.serviceDetail.salePrice)
            {
                //免费服务，不需要跳转到订单确认页面
                NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
                [dicPost setValue:[NSNumber numberWithInteger:goodsTableViewController.serviceDetail.UP_ID]  forKey:@"upId"];
                [dicPost setValue:@"SERVICE" forKey:@"orderTypeCode"];
                [dicPost setValue:@"IOS" forKey:@"sourceCode"];
                NSMutableArray* options = [NSMutableArray array];
                
                if (goodsTableViewController.serviceDetail.isMustYes)
                {
                    for (ServiceDetailOption* option in goodsTableViewController.serviceDetail.isMustYes)
                    {
                        NSDictionary* dicOption = [option mj_keyValues];
                        [options addObject:dicOption];
                    }
                }
                if (goodsTableViewController.serviceDetail.selectMust)
                {
                    for (ServiceDetailOption* option in goodsTableViewController.serviceDetail.selectMust)
                    {
                        NSDictionary* dicOption = [option mj_keyValues];
                        [options addObject:dicOption];
                    }
                }
                
                if (0 < options.count) {
                    [dicPost setValue:options forKey:@"orderBusinessDets"];
                }
                
                [self.view showWaitView];
                //直接创建订单
                [[TaskManager shareInstance] createTaskWithTaskName:@"CreateServiceOrderTask" taskParam:dicPost TaskObserver:self];
                return;
            }
//            ServiceOrderConfrimStartViewController* vcOrderConfirm = (ServiceOrderConfrimStartViewController*)[HMViewControllerManager createViewControllerWithControllerName:@"ServiceOrderConfrimStartViewController" ControllerObject:nil];
//            //[vcOrderConfirm setNeedMsgItems:needMsgs];
//            [vcOrderConfirm setServiceDetail:goodsTableViewController.serviceDetail];
            HMSecondEditionServiceOrderConfrimViewController *VC = [[HMSecondEditionServiceOrderConfrimViewController alloc] initWithServiceDetail:goodsTableViewController.serviceDetail];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    
    if ([taskname isEqualToString:@"CreateServiceOrderTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[ServiceOrder class]])
        {
            serviceOrder = (ServiceOrder*) taskResult;
        }
    }
    
}
@end

typedef enum : NSUInteger {
    DetailBaseInfoSection,
    DetailDescripitionSection,
    ServiceDetailSectionCount,
} ServiceDetailSection;

typedef enum : NSUInteger {
    ServicePriceIndex,
    ServiceBillWayIndex,
    ServiceBaseInfoIndexCount,
} ServiceBaseInfoIndex;

@implementation ServiceGoodsDetailTableViewController

- (id) initWithServiceUpID:(NSInteger)aUpId
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _upId = aUpId;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    tableheaderview = [[ServiceDetailTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 150)];
    [self.tableView setTableHeaderView:tableheaderview];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.serviceDetail) {
        [self loadServiceDetail];
    }
    
}

- (void) loadServiceDetail
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", self.upId] forKey:@"upId"];
    [self.tableView.superview showWaitView];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceDetailTask" taskParam:dicPost TaskObserver:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return ServiceDetailSectionCount;
}

- (void) serviceDetailLoaded:(ServiceDetail*) detail;
{
    if (!detail) {
        return;
    }
    _serviceDetail = detail;
    if (detail.img && 0 < detail.img)
    {
        [tableheaderview setImageUrl:detail.img];
    }
    [self.tableView reloadData];
}

- (NSArray*) serviceProductIDList
{
    NSMutableArray* idList = [NSMutableArray array];
    if (!self.serviceDetail)
    {
        return idList;
    }
    
    for (ServiceDetailOption* opt in self.serviceDetail.isMustYes)
    {
        NSString* pid = [NSString stringWithFormat:@"%ld", opt.productId];
        [idList addObject:pid];
    }
    
   
    
    return idList;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    switch (section)
    {
        case DetailBaseInfoSection:
        {
            return ServiceBaseInfoIndexCount;
        }
            break;
        case DetailDescripitionSection:
        {
            if (!self.serviceDetail || !self.serviceDetail.productDes)
            {
                return 0;
            }
            return 1;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 5)];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    return footerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case DetailDescripitionSection:
            return 40;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 40)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    switch (section)
    {
        case DetailDescripitionSection:
        {
            UIImageView* ivLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_list_line"]];
            [headerview addSubview:ivLine];
            [ivLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerview);
                make.left.equalTo(headerview).with.offset(12.5);
                make.size.mas_equalTo(CGSizeMake(2, 14));
            }];
            
            UILabel* lbTitle = [[UILabel alloc]init];
            [headerview addSubview:lbTitle];
            [lbTitle setTextColor:[UIColor mainThemeColor]];
            [lbTitle setFont:[UIFont font_30]];
            [lbTitle setText:@"介绍"];
            [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerview);
                make.left.equalTo(ivLine.mas_right).with.offset(3);
            }];
            
            UIView* lineview = [[UIView alloc]init];
            [headerview addSubview:lineview];
            [lineview setBackgroundColor:[UIColor commonControlBorderColor]];
            [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(headerview);
                make.bottom.equalTo(headerview);
                make.height.mas_equalTo(@0.5);
            }];
            break;
        }
        
    }
    return headerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case DetailDescripitionSection:
        {
            if (!self.serviceDetail || !self.serviceDetail.productDes)
            {
                return 0;
            }
            
            CGFloat cellHeight = 20 + [self.serviceDetail.productDes heightSystemFont:[UIFont font_26] width:self.tableView.width - 25];
            return cellHeight;
        }
            break;
            
        default:
            break;
    }
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =nil;
    switch (indexPath.section)
    {
        case DetailBaseInfoSection:
        {
            NSString* cellClassName = @"ServiceDetailTableViewCell";
            switch (indexPath.row)
            {
                case ServicePriceIndex:
                {
                    cellClassName = @"ServiceDetailPriceTableViewCell";
                }
                    break;
                case ServiceBillWayIndex:
                {
                    cellClassName = @"ServiceGoodsDetailBillWayTableViewCell";
                    break;
                }
                default:
                    break;
            }
            
            ServiceDetailTableViewCell* infoCell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
            if (!infoCell)
            {
                infoCell = [[NSClassFromString(cellClassName) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClassName];
            }
            [infoCell setServiceDetail:self.serviceDetail];
            [infoCell setServiceIsGoods:YES];
            cell = infoCell;
        }
            break;
        case DetailDescripitionSection:
        {
            
            ServiceDetailDescriptionTableViewCell* descCell = [tableView dequeueReusableCellWithIdentifier:@"ServiceDetailDescriptionTableViewCell"];
            if (!descCell)
            {
                descCell = [[ServiceDetailDescriptionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceDetailDescriptionTableViewCell"];
            }
            
            [descCell setServiceDetail:self.serviceDetail];
            
            cell = descCell;
            
        }
            break;
        default:
            break;
    }
    
    // Configure the cell...
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceDetailTableViewCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView.superview closeWaitView];
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
    
    if ([taskname isEqualToString:@"ServiceDetailTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[ServiceDetail class]])
        {
            ServiceDetail* detail = (ServiceDetail*) taskResult;
            [detail setUP_ID:self.upId];
            [self serviceDetailLoaded:detail];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"service_status" object:self userInfo:@{@"service_status":[NSString stringWithFormat:@"%ld",detail.service_status]}];
        }
    }
}

@end
