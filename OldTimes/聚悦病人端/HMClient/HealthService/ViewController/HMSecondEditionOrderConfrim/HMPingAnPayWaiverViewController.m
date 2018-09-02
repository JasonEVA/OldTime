//
//  HMPingAnPayWaiverViewController.m
//  HMClient
//
//  Created by jasonwang on 2016/11/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMPingAnPayWaiverViewController.h"
#import "UIImage+EX.h"

@interface HMPingAnPayWaiverViewController ()
@property (nonatomic, strong) UILabel *agreementLb;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIButton *agreeBtn;
@property (nonatomic, copy) clickBlock block;

@end

@implementation HMPingAnPayWaiverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 禁止右滑pop
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [self.navigationController interactivePopGestureRecognizer].delegate = nil;
    }

    self.title = @"免责协议";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"eeeeee"]];
    [self.view addSubview:self.agreementLb];
    [self.view addSubview:self.contentTextView];
    [self.view addSubview:self.agreeBtn];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popVC)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
    [self.agreementLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
//        make.right.left.lessThanOrEqualTo(self.view);
    }];
    
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.height.equalTo(@45);
    }];

    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreementLb.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.agreeBtn.mas_top).offset(-30);
    }];
    // Do any additional setup after loading the view.
}

- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];

    if (self.block) {
        self.block(0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)payWaiverClick:(clickBlock)block {
    self.block = block;
}
- (void)clickbutton:(id)senter {
    if (self.block) {
        self.block(1);
    }
}

- (UIButton *)agreeBtn {
    if (!_agreeBtn) {
        _agreeBtn = [UIButton new];
        [_agreeBtn setBackgroundImage:[UIImage imageColor:[UIColor colorWithHexString:@"45cec1"] size:CGSizeMake(1, 1) cornerRadius:0] forState:UIControlStateNormal];
        [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeBtn addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBtn;
}

- (UILabel *)agreementLb {
    if (!_agreementLb) {
        _agreementLb = [UILabel new];
        [_agreementLb setFont:[UIFont font_28]];
        [_agreementLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_agreementLb setText:@"您将打开平安支付，请您仔细阅读《免责协议》"];
    }
    return _agreementLb;
}

- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [UITextView new];
        [_contentTextView setEditable:NO];
        [_contentTextView setBackgroundColor:[UIColor whiteColor]];
        [_contentTextView.layer setCornerRadius:4];
        [_contentTextView.layer setShadowOffset:CGSizeMake(0, 3)];
        [_contentTextView.layer setShadowOpacity:0.1];
        [_contentTextView setFont:[UIFont systemFontOfSize:15]];
        [_contentTextView setText:@"\n    1.1、用户理解并同意，聚悦健康仅提供使用平安银行快捷支付平台（以下简称“平安支付”）的途径，对于交易对象的选择和交易的内容，应由用户自行判断，且审慎交易。用户需自行了解平安支付的适用性、各项功能、使用说明、收费标准、退款规则、服务有效期等情况并注意交易风险。\n\n    1.2、聚悦健康为平安支付制定了检测项目，但任何检测项目均不能保证应用完全可靠。聚悦健康对应用可能存在的缺陷或错误不提供任何保证或担保，对用户使用应用可能产生的损失也不承担违约或任何其他责任。\n\n    1.3、用户要求退款的，服务商可能根据收费标准或退款规定等原因拒绝退款，届时用户无权要求聚悦健康进行退款。但聚悦健康会根据用户的投诉反馈对平安支付提供的收费服务进行评估，如依照聚悦健康的判断服务商提供的收费服务存在过错或过失的，聚悦健康可协调服务商向用户退款。用户应理解聚悦健康的协调努力不保证满足用户的诉求，用户不应要求聚悦健康进行赔偿或补偿。\n\n    1.4、对于服务商提供的应用，由于网上交易平台的特殊性，且聚悦健康并不控制该等应用，用户承认并同意，聚悦健康并不对该等应用的可用性负责，且不认可该等应用所涉及的任何内容、宣传或其他材料，也不对其等负责或承担任何责任。用户进一步承认和同意，对于任何因使用或信赖类应用中获取的内容、宣传或其他材料而造成（或声称造成）的任何直接或间接损失，聚悦健康均不承担责任。"];
    }
    return _contentTextView;
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
