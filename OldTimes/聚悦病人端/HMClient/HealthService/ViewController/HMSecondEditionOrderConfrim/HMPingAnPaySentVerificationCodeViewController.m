//
//  HMPingAnPaySentVerificationCodeViewController.m
//  HMClient
//
//  Created by jasonwang on 2016/11/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMPingAnPaySentVerificationCodeViewController.h"
#import "UIImage+EX.h"
#import "HMPingAnPaySuccessView.h"
#import "HMSecondEditionSSMSRequest.h"
#import "HMSecondEditionPaySubmitRequest.h"
#import "OrderInfo.h"
#import "OrderDetailTableViewController.h"
#import "ATModuleInteractor.h"

@interface HMPingAnPaySentVerificationCodeViewController ()<TaskObserver>
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *subTitelLb;
@property (nonatomic, strong) UIView *verificatBackView;
@property (nonatomic, strong) UILabel *verificatLb;
@property (nonatomic, strong) UITextField *verificatTfd;
@property (nonatomic, strong) UILabel *verificatErrorLb;
@property (nonatomic, strong) UIButton *confirmPayBtn;
@property (nonatomic, strong) UIButton *resendVerificatBtn;
//倒计时
@property (nonatomic) NSInteger secondsCoundDown;
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, copy)   NSMutableString *time;
@property (nonatomic, strong) HMPingAnPaySuccessView *paySuccessView;
@property (nonatomic, strong) HMPingAnPayOrderModel *orderModel;
@property (nonatomic) BOOL paySuccessed;
@property (nonatomic) NSInteger getMcOrderCounts;     //getMcOrder接口的请求次数
@end

@implementation HMPingAnPaySentVerificationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.getMcOrderCounts = 0;
    [self setTitle:@"平安支付"];
    [self.view addSubview:self.titelLb];
    [self.view addSubview:self.subTitelLb];
    [self.view addSubview:self.verificatBackView];
    [self.verificatBackView addSubview:self.verificatTfd];
    [self.verificatBackView addSubview:self.verificatLb];
    [self.verificatBackView addSubview:self.resendVerificatBtn];
    [self.view addSubview:self.verificatErrorLb];
    [self.view addSubview:self.confirmPayBtn];
    [self.navigationController.view addSubview:self.paySuccessView];
    [self configElements];
    //判断订单是否过期
    [self acquireOrderDetailRequest];
    // Do any additional setup after loading the view.
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self killTimer];
    [self.paySuccessView removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(HMPingAnPaySentVerificationCodeViewControllerDelegateCallBack_showCardList)] && !self.paySuccessed) {
        [self.delegate HMPingAnPaySentVerificationCodeViewControllerDelegateCallBack_showCardList];
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)showPaySuccessView {
    [self.paySuccessView.serviceNameLb setText:self.objectName];
    [self.paySuccessView setHidden:NO];
    [self performSelector:@selector(hidePaySuccessView) withObject:nil afterDelay:3.0];
}
- (void)hidePaySuccessView {
    [self.paySuccessView setHidden:YES];
    
    [[HMViewControllerManager defaultManager].tvcRoot setSelectedIndex:0];
    [HMViewControllerManager createViewControllerWithControllerName:@"OrderDetailStartViewController" ControllerObject:[NSString stringWithFormat:@"%ld", self.serviceId]];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"CheckUserServiceTask" taskParam:nil TaskObserver:self];
}

//获取验证码
- (void)getverificatRequest {
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    NSDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",curUser.userId] forKey:@"customerId"];
    [dicPost setValue:[NSString stringWithFormat:@"%0.2f",self.amount] forKey:@"amount"];
    [dicPost setValue: self.openId forKey:@"openId"];
    
    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMSecondEditionSSMSRequest" taskParam:dicPost TaskObserver:self];
}
//确定支付请求
- (void)confirmPayRequest {
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    NSDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",curUser.userId] forKey:@"customerId"];
    [dicPost setValue:[NSString stringWithFormat:@"%0.2f",self.amount] forKey:@"amount"];
    [dicPost setValue: self.openId forKey:@"openId"];
    [dicPost setValue: self.orderModel.paydate forKey:@"paydate"];
    [dicPost setValue: self.objectName forKey:@"objectName"];
    [dicPost setValue: @"平安支付" forKey:@"remark"];
    [dicPost setValue: self.verificatTfd.text forKey:@"verifyCode"];
    [dicPost setValue: self.orderModel.orderId forKey:@"orderId"];
    [dicPost setValue: @0 forKey:@"validtime"];
    NSDictionary *dict = self.pinganOrderNo.mj_JSONObject;
    if (dict[@"sendOrderNo"]) {
        [dicPost setValue:dict[@"sendOrderNo"] forKey:@"orderNo"];
    }
    
    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMSecondEditionPaySubmitRequest" taskParam:dicPost TaskObserver:self];

}

//获取订单状态请求
- (void)acquireOrderDetailRequest {
    self.getMcOrderCounts ++;
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",self.serviceId] forKey:@"orderId"];
    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:@"OrderDetailTask" taskParam:dicPost TaskObserver:self];
}
//确定
- (void)clickbutton {
    if (self.verificatTfd.text.length) {
        [self confirmPayRequest];
    }
    else {
        UIAlertController *alterC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入验证码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alterC addAction:action];
        [self presentViewController:alterC animated:YES completion:nil];
    }
}
//获取验证码监听
- (void)getTestClick
{
    [self at_postSuccess:@"验证码已发送"];
    //设置按钮不可点击
    [self.resendVerificatBtn setEnabled:NO];
    //设置计时器
    self.secondsCoundDown = 60;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    
}
//倒计时方法，
- (void)timeFireMethod
{
    self.secondsCoundDown --;
    //更新按钮倒计时时间
    self.time = [NSMutableString stringWithFormat:@"%lds",(long)self.secondsCoundDown];
    [self.resendVerificatBtn setTitle:self.time forState:UIControlStateDisabled];
    
    if (self.secondsCoundDown == 0) {
        [self killTimer];
    }
    
}
- (void)killTimer
{
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
    //设置按钮可点击
    [self.resendVerificatBtn setEnabled:YES];
    
    [self.resendVerificatBtn setTitle:@"重发" forState:UIControlStateNormal];
}
- (void)configElements {
    [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(30);
    }];
    
    [self.subTitelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titelLb.mas_bottom).offset(10);
    }];
    
    [self.verificatBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitelLb.mas_bottom).offset(30);
        make.right.left.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.verificatLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verificatBackView).offset(15);
        make.centerY.equalTo(self.verificatBackView);
    }];
    
    [self.resendVerificatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.verificatBackView).offset(-15);
        make.centerY.equalTo(self.verificatBackView);
        make.width.equalTo(@60);
    }];
    
    [self.verificatTfd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.resendVerificatBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.verificatBackView);
        make.left.lessThanOrEqualTo(self.verificatLb.mas_right).offset(10);
    }];
    
    [self.verificatErrorLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verificatBackView.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
    }];
    
    [self.confirmPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verificatErrorLb.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@45);
    }];
    
    [self.paySuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
    
}

// 处理银行错误码
- (NSString *)processingErrorCode:(NSString *)errorCode {
    if ([errorCode isEqualToString:@"UKHPAY48"]) {
        return @"验证码错误";
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
        return @"验证码错误";
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
- (void)resendVerificatClick {
    [self getverificatRequest];
}
#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - TaskObserver

- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (taskError == StepError_None || !errorMessage) {
        return;
    }
    if ([taskname isEqualToString:@"HMSecondEditionPaySubmitRequest"] ){
        //提交订单，确认支付，错误返回
        [self.verificatErrorLb setHidden:NO];
        [self at_hideLoading];

//        [HMViewControllerManager createViewControllerWithControllerName:@"OrderListStartViewController" ControllerObject:nil];
    }
    else if ([taskname isEqualToString:@"HMSecondEditionSSMSRequest"])
    {
        [self.resendVerificatBtn setTitle:@"重发" forState:UIControlStateNormal];
        [self at_hideLoading];
    }


    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        [self at_hideLoading];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    [self at_hideLoading];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    if ([taskname isEqualToString:@"HMSecondEditionSSMSRequest"])
    {
        NSString *errorCodeString = [taskResult[@"errorCode"] stringByReplacingOccurrencesOfString:@" " withString:@""];

        if ([errorCodeString length]) {
            //错误返回,配合银行接口回调格式
            [self showAlertMessage:[NSString stringWithFormat:@"%@(%@)",taskResult[@"errorMsg"],taskResult[@"errorCode"]]];
            return;
        }

        if ([taskResult isKindOfClass:[NSDictionary class]]) {
            //获取验证码
            
            //正确返回
            self.orderModel = [HMPingAnPayOrderModel mj_objectWithKeyValues:taskResult];
            [self getTestClick];
            
            
        }
        
    }
    else if ([taskname isEqualToString:@"HMSecondEditionPaySubmitRequest"] ){
        NSString *errorCodeString = [taskResult[@"errorCode"] stringByReplacingOccurrencesOfString:@" " withString:@""];

        if ([errorCodeString length]) {
            //错误返回,配合银行接口回调格式
            [self showAlertMessage:[self processingErrorCode:taskResult[@"errorCode"]]];
            return;
        }

        //提交订单，确认支付
        if ([taskResult isKindOfClass:[NSDictionary class]]) {
            //获取验证码
            //正确返回
            if ([taskResult[@"status"] isEqualToString:@"01"]) {
                //支付成功
                [self showPaySuccessView];
                self.paySuccessed = YES;
                [self.verificatTfd resignFirstResponder];
            }
            else if ([taskResult[@"status"] isEqualToString:@"00"]) {
                //支付状态不确定
                [self acquireOrderDetailRequest];
            }
            else {
                //支付失败
                //跳转订单详情页
                [[HMViewControllerManager defaultManager].tvcRoot setSelectedIndex:0];
                [HMViewControllerManager createViewControllerWithControllerName:@"OrderDetailStartViewController" ControllerObject:[NSString stringWithFormat:@"%ld", self.serviceId]];
            }
            
            
            //第一次支付成功后，保证以后支付不打开同意协议页
            UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
            if (![[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"isAgreePingAnPayProtocol%ld",curUser.userId]]) {
                [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:[NSString stringWithFormat:@"isAgreePingAnPayProtocol%ld",curUser.userId]];
            }

            
        }

    }
    else if ([taskname isEqualToString:@"OrderDetailTask"]) {
        // 订单详情
        OrderInfo* order = taskResult[@"order"];
        if (self.getMcOrderCounts == 1) {
            // 第一次判断是否获取验证码
            if (order.orderStatus == 1) {
                //待支付状态下，发送验证码
                [self resendVerificatClick];
            }
            else {
                // 已过期
                [self showAlertMessage:@"订单已过期，请重新下单" clicked:^{
                    [self.verificatErrorLb setText:@"订单已过期，请重新下单"];
                    [self.verificatErrorLb setHidden:NO];
                    [self.confirmPayBtn setEnabled:NO];
                    [self.resendVerificatBtn setTitle:@"重发" forState:UIControlStateNormal];
                    [self.resendVerificatBtn setEnabled:NO];
                }];
            }
        }
        else {
            // 第二三次刷新订单状态
            if (order.orderStatus == 3 || order.orderStatus == 5) {
                [self showPaySuccessView];
                self.paySuccessed = YES;
                [self.verificatTfd resignFirstResponder];
            }
            else {
                if (self.getMcOrderCounts < 3) {
                    [self at_postLoading];
                    [self performSelector:@selector(acquireOrderDetailRequest) withObject:nil afterDelay:3.0f];
                }
                else {
                    //跳转订单详情页
                    [[HMViewControllerManager defaultManager].tvcRoot setSelectedIndex:0];
                    [HMViewControllerManager createViewControllerWithControllerName:@"OrderDetailStartViewController" ControllerObject:[NSString stringWithFormat:@"%ld", self.serviceId]];
                }
            }
        }
    }
}
#pragma mark - Interface

#pragma mark - init UI
- (UIButton *)confirmPayBtn {
    if (!_confirmPayBtn) {
        _confirmPayBtn = [UIButton new];
        [_confirmPayBtn setBackgroundImage:[UIImage imageColor:[UIColor colorWithHexString:@"45cec1"] size:CGSizeMake(1, 1) cornerRadius:0] forState:UIControlStateNormal];
        [_confirmPayBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmPayBtn addTarget:self action:@selector(clickbutton) forControlEvents:UIControlEventTouchUpInside];
        [_confirmPayBtn.layer setCornerRadius:4];
        [_confirmPayBtn setClipsToBounds:YES];
    }
    return _confirmPayBtn;
}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setFont:[UIFont font_30]];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_titelLb setText:@"我们已向您在银行预留的手机发送了验证码"];
    }
    return _titelLb;
}

- (UILabel *)subTitelLb {
    if (!_subTitelLb) {
        _subTitelLb = [UILabel new];
        [_subTitelLb setFont:[UIFont font_30]];
        [_subTitelLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_subTitelLb setText:@"(请在60秒内输入验证码)"];
    }
    return _subTitelLb;
}

- (UIView *)verificatBackView {
    if (!_verificatBackView) {
        _verificatBackView = [UIView new];
        [_verificatBackView setBackgroundColor:[UIColor whiteColor]];
    }
    return _verificatBackView;
}

- (UILabel *)verificatLb {
    if (!_verificatLb) {
        _verificatLb = [UILabel new];
        [_verificatLb setFont:[UIFont font_30]];
        [_verificatLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_verificatLb setText:@"验证码"];
    }
    return _verificatLb;
}

- (UILabel *)verificatErrorLb {
    if (!_verificatErrorLb) {
        _verificatErrorLb = [UILabel new];
        [_verificatErrorLb setFont:[UIFont font_30]];
        [_verificatErrorLb setTextColor:[UIColor colorWithHexString:@"ff6666"]];
        [_verificatErrorLb setText:@"验证码错误，请重新输入"];
        [_verificatErrorLb setHidden:YES];
    }
    return _verificatErrorLb;
}

- (UITextField *)verificatTfd {
    if (!_verificatTfd) {
        _verificatTfd = [UITextField new];
        [_verificatTfd setPlaceholder:@"输入验证码"];
        [_verificatTfd setTextAlignment:NSTextAlignmentRight];
    }
    return _verificatTfd;
}

- (UIButton *)resendVerificatBtn {
    if (!_resendVerificatBtn) {
        _resendVerificatBtn = [UIButton new];
        [_resendVerificatBtn.layer setCornerRadius:4];
        [_resendVerificatBtn.layer setBorderColor:[[UIColor colorWithHexString:@"31c9ba"] CGColor]];
        [_resendVerificatBtn.layer setBorderWidth:0.5];
        [_resendVerificatBtn setTitleColor:[UIColor colorWithHexString:@"31c9ba"] forState:UIControlStateNormal];
        [_resendVerificatBtn setTitle:@"60s" forState:UIControlStateNormal];
        [_resendVerificatBtn addTarget:self action:@selector(resendVerificatClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resendVerificatBtn;
}
- (HMPingAnPaySuccessView *)paySuccessView {
    if (!_paySuccessView) {
        _paySuccessView =[HMPingAnPaySuccessView new];
        [_paySuccessView setHidden:YES];
    }
    return _paySuccessView;
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
