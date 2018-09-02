//
//  HMSecondEditionPayWayViewController.m
//  HMClient
//
//  Created by jasonwang on 2016/12/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMSecondEditionPayWayViewController.h"
#import "UIImage+EX.h"
#import "ServiceInfo.h"
#import "ServiceNeedMsg.h"
#import "WXApi.h"
#import "ServiceOrder.h"
#import "OrderInfo.h"
#import "HMSecondEditionSelectPayCardView.h"
#import "HMPingAnPayWaiverViewController.h"
#import "HMPingAnPaySentVerificationCodeViewController.h"
#import "HMPingAnPayAddCardViewController.h"
#import "HMPingAnPayParmsModel.h"
#import "HMPingAnPayCardModel.h"
#import "HMPingAnPayOrderModel.h"
#import "HMSecondEditionWebViewParmsRequest.h"
#import "HMSecondEditionGetCardListRequest.h"
#import "HMSecondEditionDeleteCardRequest.h"
#import "OrderDetailTableViewController.h"
#import "ATModuleInteractor.h"
#import "HMFriendsPayQRCodeViewController.h"

#define VCHEIGHT   (ScreenHeight - 0)


@interface HMSecondEditionPayWayViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver,HMSecondEditionSelectPayCardViewDelegate,HMPingAnPayAddCardViewControllerDelegate,HMPingAnPaySentVerificationCodeViewControllerDelegate>


@property (nonatomic, strong) UILabel *selectPayWayLb;
//@property (nonatomic, strong) UILabel *payInThirtyMinLb;
@property (nonatomic, strong) UIControl *agreementLb;
@property (nonatomic, strong) UIButton *confirmPayBtn;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ServicePayWay *selectedPayway;
@property (nonatomic, strong) ServiceDetail *serviceDetail;
@property (nonatomic, strong) ServiceOrder *order;
@property (nonatomic, strong) UIButton *maskView;
@property (nonatomic, strong) HMSecondEditionSelectPayCardView *shotView;
@property (nonatomic, strong) HMPingAnPayWaiverViewController *waiverVC;
@property (nonatomic, strong) HMPingAnPayParmsModel *pinganParmsModel;
@property (nonatomic) CGFloat bottomShotViewHeight;
@property (nonatomic) BOOL isFromUnPayOrder;    //是否为未支付订单入口
@property (nonatomic, retain) OrderInfo* orderInfo;
@property (nonatomic, copy) NSString *orderJsonParam; //未支付订单传过来的订单号信息
@property (nonatomic) BOOL isAgreeThatsTime;          //本次是否已同意过免责协议
@end

@implementation HMSecondEditionPayWayViewController

- (instancetype)initWithServiceDetail:(ServiceDetail *)detail{
    if (self = [super init]) {
        self.serviceDetail = detail;
    }
    return self;
}

- (instancetype)initWithPayWayList:(NSArray *)payWayList orderInfo:(OrderInfo *)orderInfo{
    if (self = [super init]) {
        ServiceDetail *detail = [ServiceDetail new];
        detail.payWayList = [NSMutableArray arrayWithArray:payWayList];
        self.serviceDetail = detail;
        self.isFromUnPayOrder = YES;
        self.orderInfo = orderInfo;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAgreeThatsTime = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.selectPayWayLb];
//    [self.view addSubview:self.payInThirtyMinLb];
    [self.view addSubview:self.agreementLb];
    [self.view addSubview:self.confirmPayBtn];
    [self.view addSubview:self.tableView];
    self.bottomShotViewHeight = 0;
    [self configElements];
    
    self.selectedPayway = self.serviceDetail.payWayList[0];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideClick];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -private method
- (void)configElements {
    
    [self.selectPayWayLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(10);
        make.right.lessThanOrEqualTo(self.view);
    }];
    
//    [self.payInThirtyMinLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.selectPayWayLb);
//        make.right.equalTo(self.view).offset(-15);
//    }];
    
    [self.confirmPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    
    [self.agreementLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.confirmPayBtn.mas_top).offset(-15);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.selectPayWayLb.mas_bottom).offset(10);
        make.bottom.equalTo(self.agreementLb.mas_top).offset(-10);
    }];
}
- (NSAttributedString *)getAttributWithChangePart:(NSString *)changePart UnChangePart:(NSString *)unChangePart UnChangeColor:(UIColor *)unChangeColor UnChangeFont:(UIFont *)unChangeFont{
    
    NSString *allStr = [NSString stringWithFormat:@"%@%@",changePart,unChangePart];
    NSRange unChangePartRange = [allStr rangeOfString:unChangePart];
    NSMutableAttributedString *allAttStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    if (unChangeColor) {
        [allAttStr addAttribute:NSForegroundColorAttributeName value:unChangeColor range:unChangePartRange];
    }
    if (unChangeFont) {
        [allAttStr addAttribute:NSFontAttributeName value:unChangeFont range:unChangePartRange];
    }
    return allAttStr;
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
    
    if (self.selectedPayway.payWayCode)
    {
        NSString* payWayCode = self.selectedPayway.payWayCode;
        if ([payWayCode isEqualToString:@"ZFB"])
        {
            //调用支付宝
            [[AlipayPaymentUtil shareInstance] payOrder:self.order.payUrl orderId:[NSString stringWithFormat:@"%ld", (long)self.order.orderId] successBlock:^{
                [self finishPayment];
//                [HMViewControllerManager createViewControllerWithControllerName:@"PersonServicesStartViewController" ControllerObject:[NSNumber numberWithInteger:0]];
                //刷新用户服务
                [[TaskManager shareInstance] createTaskWithTaskName:@"CheckUserServiceTask" taskParam:nil TaskObserver:self];
            } failedBlock:^{
                [self cancelPayment];
//                [HMViewControllerManager createViewControllerWithControllerName:@"OrderListStartViewController" ControllerObject:nil];
            }];
            return;
        }
        if ([payWayCode isEqualToString:@"WXZF"])
        {
            NSString *jsonParam = self.order.payResult.jsonParam;
            [[WeiXinPaymentUtil shareInstance] payOrder:jsonParam orderId:[NSString stringWithFormat:@"%ld", (long)self.order.orderId] successBlock:^{
                [self finishPayment];
//                [HMViewControllerManager createViewControllerWithControllerName:@"PersonServicesStartViewController" ControllerObject:[NSNumber numberWithInteger:0]];
                //刷新用户服务
                [[TaskManager shareInstance] createTaskWithTaskName:@"CheckUserServiceTask" taskParam:nil TaskObserver:self];
            } failedBlock:^{
                [self cancelPayment];

//                [HMViewControllerManager createViewControllerWithControllerName:@"OrderListStartViewController" ControllerObject:nil];
            }];
            
            
        }
        if ([payWayCode isEqualToString:@"EPAY"]) {
            //平安支付
            [self requestCardList];
        }
        
        if ([payWayCode isEqualToString:@"QYZF"]) {
            //亲友支付
            [self showFriendsPayQRCode];
        }
        
    }
}
//显示亲友付二维码（首次支付）

- (void)showFriendsPayQRCode {
    UserInfo *userInfo = [UserInfoHelper defaultHelper].currentUserInfo;
    HMFriendsPayQRCodeViewController *VC = [[HMFriendsPayQRCodeViewController alloc] initWithOrderModel:self.order name:userInfo.userName];
    [self presentViewController:VC animated:NO completion:nil];

}
//显示亲友付二维码（待付款继续支付）

- (void)showFriendsPayQRCodeWaitPay {
    UserInfo *userInfo = [UserInfoHelper defaultHelper].currentUserInfo;
    HMFriendsPayQRCodeViewController *VC = [[HMFriendsPayQRCodeViewController alloc] initWithOrderInfoModel:self.orderInfo name:userInfo.userName];
    [self presentViewController:VC animated:NO completion:nil];
    
}
//请求平安支付需要参数
- (void)requestPingAnParms {
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    NSDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",curUser.userId] forKey:@"customerId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMSecondEditionWebViewParmsRequest" taskParam:dicPost TaskObserver:self];
    [self.view showWaitView];
    
}
//请求银行卡列表
- (void)requestCardList {

    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    NSDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",curUser.userId] forKey:@"customerId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMSecondEditionGetCardListRequest" taskParam:dicPost TaskObserver:self];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view showWaitView];
    });
    
}
//删除银行卡
- (void)deleteCardRequestWithCardModel:(HMPingAnPayCardModel *)cardModel {
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    NSDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",curUser.userId] forKey:@"customerId"];
    [dicPost setValue:cardModel.openId forKey:@"openId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMSecondEditionDeleteCardRequest" taskParam:dicPost TaskObserver:self];
    [self.view showWaitView];
}

//获取订单状态请求
- (void)acquireOrderDetailRequest {
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",self.isFromUnPayOrder ? self.orderInfo.orderId: self.order.orderId] forKey:@"orderId"];
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"OrderDetailTask" taskParam:dicPost TaskObserver:self];
}


- (void) doPayOrderWithWXZF:(NSString *)jsonParam
{
    [[WeiXinPaymentUtil shareInstance] payOrder:jsonParam orderId:0 successBlock:^{
        [self finishPayment];

//        [HMViewControllerManager createViewControllerWithControllerName:@"PersonServicesStartViewController" ControllerObject:[NSNumber numberWithInteger:0]];
        
        //刷新用户服务
        [[TaskManager shareInstance] createTaskWithTaskName:@"CheckUserServiceTask" taskParam:nil TaskObserver:nil];
    } failedBlock:^{
        [self cancelPayment];
//        [HMViewControllerManager createViewControllerWithControllerName:@"OrderListStartViewController" ControllerObject:nil];
    }];
    
}

- (void) doPayOrderWithZFB:(NSString*)payUrl
{
    //    [[AlipayPaymentUtil shareInstance] payOrder:payUrl orderId:[NSString stringWithFormat:@"%ld", order.orderId] orderType:Order_ServiceOrder];
    [[AlipayPaymentUtil shareInstance] payOrder:payUrl orderId:[NSString stringWithFormat:@"%ld", (long)self.orderInfo.orderId] successBlock:^{
        [self finishPayment];
        //                [HMViewControllerManager createViewControllerWithControllerName:@"PersonServicesStartViewController" ControllerObject:[NSNumber numberWithInteger:0]];
        //刷新用户服务
        [[TaskManager shareInstance] createTaskWithTaskName:@"CheckUserServiceTask" taskParam:nil TaskObserver:self];
    } failedBlock:^{
        [self cancelPayment];
        //                [HMViewControllerManager createViewControllerWithControllerName:@"OrderListStartViewController" ControllerObject:nil];
    }];

}
// 取消支付
- (void)cancelPayment {
    self.isFromUnPayOrder ? [self hideClick]:[self goToOrderDetailVC];
}

// 支付完成
- (void)finishPayment {
    [self goToOrderDetailVC];
}

- (void)goToOrderDetailVC {
    [self hideClick];
    OrderDetailStartViewController *VC = [[OrderDetailStartViewController alloc]initWithOrderId:[NSString stringWithFormat:@"%ld",(long)(self.isFromUnPayOrder ? self.orderInfo.orderId: self.order.orderId)]];
    [[ATModuleInteractor sharedInstance] popFirstVC:self pushSecondVC:VC];
}
// 处理银行错误码
- (NSString *)processingErrorCode:(NSString *)errorCode {
    if ([errorCode isEqualToString:@"UKHPAY48"]) {
        return @"验证码输入格式错误";
    }
    else if ([errorCode isEqualToString:@"UKHPAY51"])
    {
        return @"发送验证码失败";
    }
    else if ([errorCode isEqualToString:@"UKHPAY12"])
    {
        return @"订单已存在";
    }
    else if ([errorCode isEqualToString:@"UKHPY62"] || [errorCode isEqualToString:@"UKHPY60"])
    {
        return @"交易失败，详情请咨询你的发卡行";
    }
    else if ([errorCode isEqualToString:@"UKHPY63"])
    {
        return @"卡状态不正确";
    }
    else if ([errorCode isEqualToString:@"UKHPY64"])
    {
        return @"卡上的余额不足";
    }
    else if ([errorCode isEqualToString:@"UKHPY71"])
    {
        return @"动态口令或短信验证码校验失败";
    }
    else if ([errorCode isEqualToString:@"UKHPY73"])
    {
        return @"支付卡已超过有效期";
    }
    else if ([errorCode isEqualToString:@"UKHPY81"])
    {
        return @"月累计交易笔数（金额）超限";
    }
    else {
        return @"未知错误，请联系客服处理";
    }
}

#pragma mark - event Response

- (void)hideClick {
    [UIView animateWithDuration:0.2 animations:^{
        [self.shotView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, self.bottomShotViewHeight)];
    }];
    [self.maskView removeFromSuperview];
    [self.shotView removeFromSuperview];
}

- (void)showShootBottomView {
    
    [self.shotView updateUI];
    [self.navigationController.view addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
    [self.navigationController.view addSubview:self.shotView];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.shotView setFrame:CGRectMake(0, VCHEIGHT - MIN(self.bottomShotViewHeight, VCHEIGHT * 0.63), ScreenWidth, MIN(self.bottomShotViewHeight, VCHEIGHT * 0.63) )];
    }];
    
}


- (void) commitButtonClicked:(id) sender
{
    if (!self.isFromUnPayOrder) {
        //首次支付流程
        
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
        if (self.recommendUserId && self.recommendUserId.length > 0)
        {
            [dicPost setValue:self.recommendUserId forKey:@"recommendUserId"];
        }
        
        if (0 < needMsgItems.count) {
            [dicPost setValue:needMsgItems forKey:@"needMsgData"];
        }
        
        if (self.selectedPayway.payWayCode)
        {
            [dicPost setValue:self.selectedPayway.payWayCode forKey:@"payWayCode"];
            
            if ([self.selectedPayway.payWayCode isEqualToString:@"WXZF"])
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
        
        if (self.recommendUserId ) {
            [dicPost setValue:self.recommendUserId forKey:@"recommendUserId"];
        }
        
        //创建订单 CreateServiceOrderTask
        [self.view showWaitView];
        
        [[TaskManager shareInstance] createTaskWithTaskName:@"CreateServiceOrderTask" taskParam:dicPost TaskObserver:self];
    }
    else {
        //由未支付订单进行支付流程
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
        NSMutableDictionary *wxPost = [NSMutableDictionary dictionary];
        [dicPost setValue:self.selectedPayway.payWayCode forKey:@"payWayCode"];
        [dicPost setValue:[NSString stringWithFormat:@"%ld", self.orderInfo.orderId] forKey:@"orderId"];
        [dicPost setValue:wxPost forKey:@"extra"];

        [self.view showWaitView];
        [[TaskManager shareInstance] createTaskWithTaskName:@"OrderPayInfoTask" taskParam:dicPost TaskObserver:self];

    }
    
}

#pragma mark - HMSecondEditionSelectPayCardViewDelegate
//添加银行卡
- (void)HMSecondEditionSelectPayCardViewDelegateCallBack_addCard {
    [self requestPingAnParms];
}
//删除银行卡
- (void)HMSecondEditionSelectPayCardViewDelegateCallBack_deleteCard:(HMPingAnPayCardModel *)deleteCard {
    UIAlertController *alterC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认删除此银行卡" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *actDelete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteCardRequestWithCardModel:deleteCard];
    }];
    
    [alterC addAction:action];
    [alterC addAction:actDelete];
    [self presentViewController:alterC animated:YES completion:nil];
    
}
#pragma mark -HMPingAnPayAddCardViewControllerDelegate
//添加银行卡完毕回调
- (void)HMPingAnPayAddCardViewControllerDelegateCallBack_reLoadCardList {
    [self acquireOrderDetailRequest];
}
#pragma mark -HMPingAnPaySentVerificationCodeViewControllerDelegate
//从验证码界面返回，显示银行卡列表
- (void)HMPingAnPaySentVerificationCodeViewControllerDelegateCallBack_showCardList {
    [self acquireOrderDetailRequest];
}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.serviceDetail.payWayList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    ServicePayWay *payway = self.serviceDetail.payWayList[indexPath.row];
    [cell.textLabel setText:payway.payWayName];
    
    NSString* imgName = @"icon_pay_aliPay";
    if (!payway.payWayCode || 0 == payway.payWayCode.length) {
        
    }
    if ([payway.payWayCode isEqualToString:@"ZFB"])
    {
        imgName = @"icon_pay_aliPay";
    }
    else if ([payway.payWayCode isEqualToString:@"WXZF"])
    {
        imgName = @"icon_pay_tiny";
    }
    else if ([payway.payWayCode isEqualToString:@"EPAY"])
    {
        imgName = @"pinganpay";
    }
    else if ([payway.payWayCode isEqualToString:@"QYZF"])
    {
        imgName = @"ic_friend";
    }
    
    [cell.imageView setImage:[UIImage imageNamed:imgName]];
    UIImageView *accessView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_unselect"] highlightedImage:[UIImage imageNamed:@"pay_selected"]];
    [accessView setHighlighted:[self.selectedPayway.payWayCode isEqualToString:payway.payWayCode]];
    [cell setAccessoryView:accessView];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ServicePayWay *payway = self.serviceDetail.payWayList[indexPath.row];
    if ([self.selectedPayway.payWayCode isEqualToString:payway.payWayCode]) {
        return;
    }
    self.selectedPayway = payway;
    [self.tableView reloadData];
}
#pragma mark - TaskObserver

- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (StepError_None != taskError)
    {
        [self.view closeWaitView];
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    [self.view closeWaitView];
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
            _serviceDetail.service_status = 1;  //表示已购买
            self.order = (ServiceOrder*) taskResult;
            if (self.order.payStatus && [self.order.payStatus isEqualToString:@"free"])
            {
                //免支付，直接跳转到订单详情
                OrderInfo* orderInfo = [[OrderInfo alloc]init];
                [orderInfo setOrderId:self.order.orderId];
                [orderInfo setPayStatus:self.order.payStatus];
                //跳转到订单详情
                [HMViewControllerManager createViewControllerWithControllerName:@"OrderDetailStartViewController" ControllerObject:[NSString stringWithFormat:@"%ld", self.order.orderId]];
                //刷新用户服务
                [[TaskManager shareInstance] createTaskWithTaskName:@"CheckUserServiceTask" taskParam:nil TaskObserver:self];
                return;
            }
            //进行支付
            [self doPayOrder];
            return;
        }
    }
    else if ([taskname isEqualToString:@"HMSecondEditionWebViewParmsRequest"]) {
        //获取webview参数返回
        if ([taskResult[@"errorCode"] length]) {
            //错误返回,配合银行接口回调格式
            [self showAlertMessage:[NSString stringWithFormat:@"%@(%@)",taskResult[@"errorMsg"],taskResult[@"errorCode"]]];
            return;
        }
        if ([taskResult isKindOfClass:[NSDictionary class]]) {
            [self hideClick];
            self.pinganParmsModel = [HMPingAnPayParmsModel mj_objectWithKeyValues:taskResult];
            HMPingAnPayAddCardViewController *VC = [HMPingAnPayAddCardViewController new];
            VC.model = self.pinganParmsModel;
            [VC setDelegate:self];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    else if ([taskname isEqualToString:@"HMSecondEditionGetCardListRequest"]) {
        //获取银行卡列表
        if ([taskResult[@"errorCode"] length]) {
            //错误返回,配合银行接口回调格式
            [self showAlertMessage:[NSString stringWithFormat:@"%@(%@)",taskResult[@"errorMsg"],taskResult[@"errorCode"]]];
            return;
        }
        if ([taskResult isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = taskResult[@"unionInfo"];
            NSArray *arr = [HMPingAnPayCardModel mj_objectArrayWithKeyValuesArray:dict];
            self.bottomShotViewHeight = 255 + arr.count * 60;
            [self.shotView fillDataWithArray:arr];
            UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
            if (![[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"isAgreePingAnPayProtocol%ld",curUser.userId]]&&!self.isAgreeThatsTime) {
                [self.navigationController pushViewController:self.waiverVC animated:YES];
            }else{
                [self showShootBottomView];
            }
        }
    }
    else if ([taskname isEqualToString:@"HMSecondEditionDeleteCardRequest"]) {
        //删除银行卡
        if ([taskResult[@"errorCode"] length]) {
            //错误返回,配合银行接口回调格式
            [self showAlertMessage:[NSString stringWithFormat:@"%@(%@)",taskResult[@"errorMsg"],taskResult[@"errorCode"]]];
            return;
        }
        [self requestCardList];
    }
    else if ([taskname isEqualToString:@"OrderPayInfoTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
            NSString* paywayCode = [dicParam valueForKey:@"payWayCode"];
            NSString* payUrl = [dicResult valueForKey:@"payUrl"];
            
            if (paywayCode && [paywayCode isEqualToString:@"ZFB"])
            {
                [self doPayOrderWithZFB:payUrl];
            }
            
            if (paywayCode && [paywayCode isEqualToString:@"WXZF"])
            {
                NSString *jsonParam = dicResult[@"jsonParam"];
                [self doPayOrderWithWXZF:jsonParam];
            }
            if (paywayCode && [paywayCode isEqualToString:@"EPAY"]) {
                //平安支付
                NSString *jsonParam = dicResult[@"jsonParam"];
                self.orderJsonParam = jsonParam;
                [self requestCardList];
            }
            
            if (paywayCode && [paywayCode isEqualToString:@"QYZF"])
            {// 亲友支付
                NSString *jumpUrl = dicResult[@"jumpUrl"];
                self.orderInfo.jumpUrl = jumpUrl;
                [self showFriendsPayQRCodeWaitPay];
                
            }
        }
    }
    else if ([taskname isEqualToString:@"OrderDetailTask"]) {
        // 检查订单状态
        OrderInfo* order = taskResult[@"order"];
            if (order.orderStatus == 1) {
                //待支付状态下，请求卡列表
                [self requestCardList];
            }
    }

}

#pragma mark - Interface

- (void) aggrementTapAction:(id)tap
{
    //跳转到支付协议界面 PaymentAggrementStartViewController
//    [HMViewControllerManager createViewControllerWithControllerName:@"PaymentAggrementStartViewController" ControllerObject:nil];
    
}

#pragma mark - init UI


- (UILabel *)selectPayWayLb {
    if (!_selectPayWayLb) {
        _selectPayWayLb = [UILabel new];
        [_selectPayWayLb setFont:[UIFont font_30]];
        [_selectPayWayLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_selectPayWayLb setText:@"选择支付方式"];
    }
    return _selectPayWayLb;
}
//- (UILabel *)payInThirtyMinLb {
//    if (!_payInThirtyMinLb) {
//        _payInThirtyMinLb = [UILabel new];
//        [_payInThirtyMinLb setFont:[UIFont font_30]];
//        [_payInThirtyMinLb setTextColor:[UIColor colorWithHexString:@"ff6666"]];
//        [_payInThirtyMinLb setText:@"下单后30分钟内支付"];
//    }
//    return _payInThirtyMinLb;
//}
- (UIControl *)agreementLb {
    if (!_agreementLb) {
        _agreementLb = [[UIControl alloc] init];
        UILabel* agreementLb = [[UILabel alloc] init];
        
        [agreementLb setFont:[UIFont font_28]];
        [agreementLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [agreementLb setAttributedText:[self getAttributWithChangePart:@"下单即代表您同意" UnChangePart:@"聚悦健康支付协议" UnChangeColor:[UIColor colorWithHexString:@"45cec1"] UnChangeFont:[UIFont font_28]]];
        
        [_agreementLb addSubview:agreementLb];
        [agreementLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_agreementLb);
        }];
        
        [_agreementLb addTarget:self action:@selector(aggrementTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreementLb;
}

- (UIButton *)confirmPayBtn {
    if (!_confirmPayBtn) {
        _confirmPayBtn = [UIButton new];
        [_confirmPayBtn setBackgroundImage:[UIImage imageColor:[UIColor colorWithHexString:@"45cec1"] size:CGSizeMake(1, 1) cornerRadius:0] forState:UIControlStateNormal];
        [_confirmPayBtn setTitle:@"确定支付" forState:UIControlStateNormal];
        [_confirmPayBtn addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmPayBtn;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setRowHeight:60];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
    }
    return _tableView;
}

- (UIButton *)maskView {
    if (!_maskView) {
        _maskView = [UIButton new];
        [_maskView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
        [_maskView setUserInteractionEnabled:YES];
        [_maskView addTarget:self action:@selector(cancelPayment) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskView;
}

- (HMSecondEditionSelectPayCardView *)shotView {
    if (!_shotView) {
        _shotView = [HMSecondEditionSelectPayCardView new];
        [_shotView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, self.bottomShotViewHeight)];
        [_shotView setDelegate:self];
        [_shotView btnClick:^(NSInteger tag) {
            if (!tag) {
                //返回
                [self cancelPayment];
            }
            else {
                //确定支付
                [self hideClick];
                float totalPrice = self.serviceDetail.salePrice;
                if (self.serviceDetail.selectMust)
                {
                    for (ServiceDetailOption* opt in self.serviceDetail.selectMust)
                    {
                        totalPrice += opt.salePrice;
                    }
                }
                
                HMPingAnPaySentVerificationCodeViewController *VC = [HMPingAnPaySentVerificationCodeViewController new];
                [VC setDelegate:self];
                if (self.shotView.selectedCard.openId) {
                    VC.openId = self.shotView.selectedCard.openId;
                    VC.amount = self.isFromUnPayOrder ? self.orderInfo.orderMoney: totalPrice;
                    VC.objectName = self.isFromUnPayOrder ? self.orderInfo.orderName:self.serviceDetail.comboName;
                    VC.pinganOrderNo = self.isFromUnPayOrder ? self.orderJsonParam:self.order.payResult.jsonParam;
                    VC.serviceId = self.isFromUnPayOrder ? self.orderInfo.orderId: self.order.orderId;
                    [self.navigationController pushViewController:VC animated:YES];
                }
                else {
                    UIAlertController *alterC = [UIAlertController alertControllerWithTitle:@"提示" message:@"必须先添加一张银行卡" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alterC addAction:action];
                    [self presentViewController:alterC animated:YES completion:nil];
                    
                }
                
                
            }
            
        }];
    }
    return _shotView;
}
- (HMPingAnPayWaiverViewController *)waiverVC {
    if (!_waiverVC) {
        _waiverVC = [HMPingAnPayWaiverViewController new];
        [_waiverVC payWaiverClick:^(NSInteger tag) {
            if (tag) {
                // 同意
                [self.navigationController popViewControllerAnimated:NO];
                self.isAgreeThatsTime = YES;

                [self acquireOrderDetailRequest];

            }
            else {
                // 不同意 返回
                if (!self.isFromUnPayOrder) {
                    OrderDetailStartViewController *VC = [[OrderDetailStartViewController alloc]initWithOrderId:[NSString stringWithFormat:@"%ld",(long)(self.isFromUnPayOrder ? self.orderInfo.orderId: self.order.orderId)]];
                    [[ATModuleInteractor sharedInstance] popFirstVC:self pushSecondVC:VC];
                }
            }
        }];
        
    }
    return _waiverVC;
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
