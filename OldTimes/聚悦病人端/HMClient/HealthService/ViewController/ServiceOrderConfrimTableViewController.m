//
//  ServiceOrderConfrimTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceOrderConfrimTableViewController.h"
#import "ServiceOrderConfirmInfoTableViewCell.h"
#import "ServiceNeedMsg.h"
#import "ServiceOrder.h"
#import "OrderInfo.h"
#import "WXApi.h"

@interface ServiceOrderConfrimStartViewController()
<TaskObserver>
{
    
    ServiceOrderConfrimTableViewController* tvcOrderConfirm;
    ServiceOrder* order;
    UIView* licenceView;
    UIButton* commitButton;
}
@end

@interface ServiceOrderConfrimTableViewController ()
{
    ServiceDetail* serviceDetail;
    
}

- (id) initWithServiceDetail:(ServiceDetail*) detail;

@end

@implementation ServiceOrderConfrimStartViewController

@synthesize serviceDetail = _serviceDetail;
@synthesize needMsgItems = _needMsgItems;


- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"确认订单"];
    
    if (_serviceDetail)
    {
        [self createOrderConfirmTable];
    }
    
    
    licenceView = [[UIView alloc]init];
    [self.view addSubview:licenceView];
    [licenceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(25);
        make.top.equalTo(tvcOrderConfirm.tableView.mas_bottom).with.offset(18);
    }];
    
    UILabel* lbLicence = [[UILabel alloc]init];
    [licenceView addSubview:lbLicence];
    [lbLicence setBackgroundColor:[UIColor clearColor]];
    [lbLicence setText:@"下单即表示您同意"];
    [lbLicence setTextColor:[UIColor commonGrayTextColor]];
    [lbLicence setFont:[UIFont font_22]];
    [lbLicence mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(licenceView);
        make.centerY.equalTo(licenceView);
    }];
    
    UIControl* licenceCtrl = [[UIControl alloc]init];
    [licenceView addSubview:licenceCtrl];
    [licenceCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbLicence.mas_right);
        make.right.equalTo(licenceView);
        make.centerY.equalTo(licenceView);
    }];
    
    UILabel* lbname = [[UILabel alloc]init];
    [licenceCtrl addSubview:lbname];
    [lbname setBackgroundColor:[UIColor clearColor]];
    [lbname setText:@"聚悦健康支付协议"];
    [lbname setTextColor:[UIColor mainThemeColor]];
    [lbname setFont:[UIFont font_22]];
    [lbname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(licenceCtrl);
        make.right.equalTo(licenceCtrl);
        make.centerY.equalTo(licenceView);
    }];
    
    commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:commitButton];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton setTitle:@"确定支付" forState:UIControlStateNormal];
    if (0 == _serviceDetail.salePrice)
    {
        [commitButton setTitle:@"确定购买" forState:UIControlStateNormal];
    }
    [commitButton.titleLabel setFont:[UIFont font_30]];
    [commitButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 40) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [commitButton.layer setCornerRadius:2.5];
    [commitButton.layer setMasksToBounds:YES];
    
    [commitButton addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.top.equalTo(licenceView.mas_bottom).with.offset(4);
        make.height.mas_equalTo(@45);
    }];

}

- (void) setServiceDetail:(ServiceDetail *)serviceDetail
{
    _serviceDetail = serviceDetail;
    if (_serviceDetail && !tvcOrderConfirm)
    {
        [self createOrderConfirmTable];
    }
}

- (void) createOrderConfirmTable
{
    tvcOrderConfirm = [[ServiceOrderConfrimTableViewController alloc]initWithServiceDetail:_serviceDetail];
    [self addChildViewController:tvcOrderConfirm];
    [tvcOrderConfirm.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tvcOrderConfirm.tableView];
    
    [tvcOrderConfirm.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-100);
    }];
    
    //NSLog(@"table contentHeight %f", tvcOrderConfirm.tableView.contentSize.height);
}

- (void) subviewLayout
{
    
}

- (void) commitButtonClicked:(id) sender
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:_serviceDetail.UP_ID]  forKey:@"upId"];
    [dicPost setValue:@"SERVICE" forKey:@"orderTypeCode"];
    [dicPost setValue:@"IOS" forKey:@"sourceCode"];
    NSMutableArray* options = [NSMutableArray array];
    
    if (_serviceDetail.isMustYes)
    {
        for (ServiceDetailOption* option in _serviceDetail.isMustYes)
        {
            NSDictionary* dicOption = [option mj_keyValues];
            [options addObject:dicOption];
        }
    }
    if (_serviceDetail.selectMust)
    {
        for (ServiceDetailOption* option in _serviceDetail.selectMust)
        {
            NSDictionary* dicOption = [option mj_keyValues];
            [options addObject:dicOption];
        }
    }
    
    if (0 < options.count) {
        [dicPost setValue:options forKey:@"orderBusinessDets"];
    }
    
    //needMsgData
    NSMutableArray* needMsgItems = [NSMutableArray array];
    if (_needMsgItems)
    {
        for (ServiceNeedMsg* needMsg in _needMsgItems)
        {
            NSDictionary* dicMsg = [needMsg mj_keyValues];
            [needMsgItems addObject:dicMsg];
        }
    }
    if (0 < needMsgItems.count) {
        [dicPost setValue:needMsgItems forKey:@"needMsgData"];
    }
    
    if (tvcOrderConfirm.selectedPayway.payWayCode)
    {
        [dicPost setValue:tvcOrderConfirm.selectedPayway.payWayCode forKey:@"payWayCode"];
        
        if ([tvcOrderConfirm.selectedPayway.payWayCode isEqualToString:@"WXZF"])
        {
            
            //检查微信是否已被用户安装
            if (![WXApi isWXAppInstalled])
            {
                [self.view showAlertMessage:@"未检测到微信客户端，调用失败"];
                return;
            }
            
            //判断当前微信的版本是否支持OpenApi
            if (![WXApi isWXAppSupportApi])
            {
                [self.view showAlertMessage:@"当前版本不支持微信支付"];
                return;
            }

            NSMutableDictionary *wxPost = [NSMutableDictionary dictionary];
            [wxPost setValue:@"APP" forKey:@"tradeType"];
            [dicPost setValue:wxPost forKey:@"extra"];
            [dicPost setValue:@"mobile" forKey:@"payType"];
            
             NSInteger calltype = [PlantformConfig calltype];
             
             [dicPost setValue:[NSString stringWithFormat:@"%ld", calltype] forKey:@"calltype"];
            //[dicPost setValue:@"7" forKey:@"calltype"];
        }
    }
    
    //创建订单 CreateServiceOrderTask
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"CreateServiceOrderTask" taskParam:dicPost TaskObserver:self];
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
    
    if ([taskname isEqualToString:@"CreateServiceOrderTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[ServiceOrder class]])
        {
            
            [commitButton setTitle:@"已购买" forState:UIControlStateDisabled];
            [commitButton setEnabled:NO];
            _serviceDetail.service_status = 1;  //表示已购买
            order = (ServiceOrder*) taskResult;
            if (order.payStatus && [order.payStatus isEqualToString:@"free"])
            {
                
                //免支付，直接跳转到订单详情
                OrderInfo* orderInfo = [[OrderInfo alloc]init];
                [orderInfo setOrderId:order.orderId];
                [orderInfo setPayStatus:order.payStatus];
                //跳转到订单详情
                [HMViewControllerManager createViewControllerWithControllerName:@"OrderDetailStartViewController" ControllerObject:[NSString stringWithFormat:@"%ld", order.orderId]];
                //刷新用户服务
                [[TaskManager shareInstance] createTaskWithTaskName:@"CheckUserServiceTask" taskParam:nil TaskObserver:self];
                return;
            }
            //进行支付
            [self doPayOrder];
            return;
        }
    }
}

- (void) doPayOrder
{
    NSString* appscheme = @"jyhmclient";
#ifdef kPlantform_JuYue
    appscheme = @"jyhmclient";
#endif
    
#ifdef kPlantform_ChongYi
    appscheme = @"cyhmclient";
#endif
    
#ifdef kPlantform_XiNan
    appscheme = @"xnhmclient";
#endif
    
    if (tvcOrderConfirm.selectedPayway.payWayCode)
    {
        NSString* payWayCode = tvcOrderConfirm.selectedPayway.payWayCode;
        if ([payWayCode isEqualToString:@"ZFB"])
        {
            //调用支付宝
            [[AlipayPaymentUtil shareInstance] payOrder:order.payUrl orderId:[NSString stringWithFormat:@"%ld", (long)order.orderId] successBlock:^{
                [[HMViewControllerManager defaultManager].tvcRoot setSelectedIndex:3];
                [HMViewControllerManager createViewControllerWithControllerName:@"PersonServicesStartViewController" ControllerObject:[NSNumber numberWithInteger:0]];
                //刷新用户服务
                [[TaskManager shareInstance] createTaskWithTaskName:@"CheckUserServiceTask" taskParam:nil TaskObserver:self];
            } failedBlock:^{
                [HMViewControllerManager createViewControllerWithControllerName:@"OrderListStartViewController" ControllerObject:nil];
            }];
            return;
        }
        
        if ([payWayCode isEqualToString:@"WXZF"])
        {
            NSString *jsonParam = order.payResult.jsonParam;
            [[WeiXinPaymentUtil shareInstance] payOrder:jsonParam orderId:[NSString stringWithFormat:@"%ld", (long)order.orderId] successBlock:^{
                [[HMViewControllerManager defaultManager].tvcRoot setSelectedIndex:3];
                [HMViewControllerManager createViewControllerWithControllerName:@"PersonServicesStartViewController" ControllerObject:[NSNumber numberWithInteger:0]];
                //刷新用户服务
                [[TaskManager shareInstance] createTaskWithTaskName:@"CheckUserServiceTask" taskParam:nil TaskObserver:self];
            } failedBlock:^{
                 [HMViewControllerManager createViewControllerWithControllerName:@"OrderListStartViewController" ControllerObject:nil];
            }];
           
            
        }
    }
}

@end

typedef enum : NSUInteger {
    ServiceOrderConfrimServiceSection,
    ServiceOrderConfrimPriceSection,
    ServiceOrderConfrimPaywaySection,
    //,
    ServiceOrderConfrimTableSectionCount,
} ServiceOrderConfrimTableSection;

@implementation ServiceOrderConfrimTableViewController

- (id) initWithServiceDetail:(ServiceDetail*) detail
{
    self = [super initWithStyle:UITableViewStylePlain];
    if(self)
    {
        serviceDetail = detail;
        if (serviceDetail.payWayList && 0 < serviceDetail.payWayList.count)
        {
            _selectedPayway = [serviceDetail.payWayList objectAtIndex:0];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorColor:[UIColor commonBackgroundColor]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return ServiceOrderConfrimTableSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    switch (section) {
        case ServiceOrderConfrimServiceSection:
        case ServiceOrderConfrimPriceSection:
            return 1;
            break;
        case ServiceOrderConfrimPaywaySection:
            if (serviceDetail.payWayList)
            {
                return serviceDetail.payWayList.count;
            }
            
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case ServiceOrderConfrimServiceSection:
            return 70;
            break;
        case ServiceOrderConfrimPriceSection:
            return 37;
            break;
        default:
            break;
    }
    return 45;
}

- (CGFloat) footerviewHeight:(NSInteger)section
{
    switch (section)
    {
        case ServiceOrderConfrimPriceSection:
            return 31;
            break;
            
        default:
            break;
    }
    return 0.5;
}


- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self footerviewHeight:section];
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, [self footerviewHeight:section])];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    switch (section)
    {
        case ServiceOrderConfrimPriceSection:
        {
            UILabel* lbNotice = [[UILabel alloc]init];
           
            [footerview addSubview:lbNotice];
            [lbNotice setText:@"下单后30分钟内支付"];
            [lbNotice setTextColor:[UIColor commonRedColor]];
            [lbNotice setFont:[UIFont font_24]];
            [lbNotice setBackgroundColor:[UIColor clearColor]];
            
            [lbNotice mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(footerview).with.offset(12.5);
                make.centerY.equalTo(footerview);
            }];
        }
            break;
            
        default:
            break;
    }
    return footerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self headerviewHeight:section];
}

- (CGFloat) headerviewHeight:(NSInteger) section
{
    switch (section)
    {
        case ServiceOrderConfrimPaywaySection:
            return 29;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, [self headerviewHeight:section])];
    switch (section)
    {
        case ServiceOrderConfrimPaywaySection:
        {
            UILabel* lbNotice = [[UILabel alloc]init];
           
            [headerview addSubview:lbNotice];
            [lbNotice setText:@"请选择一种支付方式"];
            [lbNotice setTextColor:[UIColor commonGrayTextColor]];
            [lbNotice setFont:[UIFont font_24]];
            [lbNotice setBackgroundColor:[UIColor clearColor]];
            
            [lbNotice mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headerview).with.offset(12.5);
                make.centerY.equalTo(headerview);
            }];
            
            UIView* bottomLine = [[UIView alloc]init];
            [bottomLine setBackgroundColor:[UIColor commonControlBorderColor]];
            [headerview addSubview:bottomLine];
            [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.and.bottom.equalTo(headerview);
                make.height.mas_equalTo(@0.5);
            }];
        }
            break;
            
        default:
            break;
    }
    return headerview;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case ServiceOrderConfrimServiceSection:
        {
            cell = [self serviceInfoCell];
        }
            break;
        case ServiceOrderConfrimPriceSection:
        {
            cell = [self servicePriceCell];
        }
            break;
        case ServiceOrderConfrimPaywaySection:
        {
            cell = [self paywayCell:indexPath.row];
        }
            break;
        default:
            break;
    }
    
    // Configure the cell...
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceOrderConfrimTableViewCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (UITableViewCell*) serviceInfoCell
{
    ServiceOrderConfirmInfoTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ServiceOrderConfirmInfoTableViewCell"];
    if (!cell)
    {
        cell = [[ServiceOrderConfirmInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceOrderConfirmInfoTableViewCell"];
    }
    [cell setServiceDetail:serviceDetail];
    
    return cell;
}

- (UITableViewCell*) servicePriceCell
{
    ServiceOrderConfirmPriceTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ServiceOrderConfirmPriceTableViewCell"];
    if (!cell)
    {
        cell = [[ServiceOrderConfirmPriceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceOrderConfirmPriceTableViewCell"];
    }
    float totalPrice = serviceDetail.salePrice;
    if (serviceDetail.selectMust)
    {
        for (ServiceDetailOption* opt in serviceDetail.selectMust)
        {
            totalPrice += opt.salePrice;
        }
    }
    [cell setServicePrice:totalPrice];
    
    return cell;
}

- (UITableViewCell*) paywayCell:(NSInteger) row
{
    ServiceOrderConfirmPaywayTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ServiceOrderConfirmPaywayTableViewCell"];
    if (!cell)
    {
        cell = [[ServiceOrderConfirmPaywayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceOrderConfirmPaywayTableViewCell"];
    }
    
    ServicePayWay* payway = serviceDetail.payWayList[row];
    [cell setPayway:payway];
    
    [cell setIsSelected:(payway == _selectedPayway)];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case ServiceOrderConfrimPaywaySection:
        {
            ServicePayWay* payway = serviceDetail.payWayList[indexPath.row];
            _selectedPayway = payway;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:ServiceOrderConfrimPaywaySection];
            [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
            
        default:
            break;
    }
}

@end
