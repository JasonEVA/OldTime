
//
//  HMSecondEditionServiceOrderConfrimViewController.m
//  HMClient
//
//  Created by jasonwang on 2016/11/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMSecondEditionServiceOrderConfrimViewController.h"
#import "HMSecondEditionServiceOrderConfrimDetailView.h"
#import "ServiceInfo.h"
#import "HMSecondEditionPayWayViewController.h"

@interface HMSecondEditionServiceOrderConfrimViewController ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *payFeeTitelLb;
@property (nonatomic, strong) UILabel *payFeeValueLb;
@property (nonatomic, strong) HMSecondEditionServiceOrderConfrimDetailView *serviceDetailView;
@property (nonatomic, strong) ServiceDetail *serviceDetail;
@property (nonatomic, strong) HMSecondEditionPayWayViewController *payWayVC;
@end

@implementation HMSecondEditionServiceOrderConfrimViewController

- (instancetype)initWithServiceDetail:(ServiceDetail *)detail{
    if (self = [super init]) {
        self.serviceDetail = detail;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 禁用滑动返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        
    }
    
    [self setTitle:@"确认订单"];

    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self.view addSubview:self.topView];
    [self.topView addSubview:self.payFeeValueLb];
    [self.topView addSubview:self.payFeeTitelLb];
    [self.view addSubview:self.serviceDetailView];
    [self addChildViewController:self.payWayVC];
    [self.view addSubview:self.payWayVC.view];
    
    [self.payWayVC setRecommendUserId:self.recommendUserId];
    
    [self configElements];
    
    
    [self fillData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@170);
    }];
    
    [self.payFeeTitelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView).offset(30);
        make.centerX.equalTo(self.topView);
    }];
    
    [self.payFeeValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView);
        make.top.equalTo(self.payFeeTitelLb.mas_bottom).offset(12.5);
    }];
    
    [self.serviceDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payFeeValueLb.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@142.5);
    }];
    
    [self.payWayVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serviceDetailView.mas_bottom).offset(25);
        make.left.right.bottom.equalTo(self.view);
    }];
    
}

- (void)fillData{
    float totalPrice = self.serviceDetail.salePrice;
    if (self.serviceDetail.selectMust)
    {
        for (ServiceDetailOption* opt in self.serviceDetail.selectMust)
        {
            totalPrice += opt.salePrice;
        }
    }
    //    [self.payFeeValueLb setText:[NSString stringWithFormat:@"%.2f", totalPrice]];
    [self.payFeeValueLb setAttributedText:[self getAttributWithChangePart:[NSString stringWithFormat:@"%.2f", totalPrice] UnChangePart:@"元" UnChangeColor:[UIColor colorWithHexString:@"ffffff"] UnChangeFont:[UIFont font_28]]];
    [self.serviceDetailView fillDataWith:self.serviceDetail];
    
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

#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface

#pragma mark - init UI

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        [_topView setBackgroundColor:[UIColor colorWithHexString:@"45cec1"]];
    }
    return _topView;
}
- (UILabel *)payFeeTitelLb {
    if (!_payFeeTitelLb) {
        _payFeeTitelLb = [UILabel new];
        [_payFeeTitelLb setFont:[UIFont font_28]];
        [_payFeeTitelLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_payFeeTitelLb setAlpha:0.8];
        [_payFeeTitelLb setText:@"支付费用"];
    }
    return _payFeeTitelLb;
}

- (UILabel *)payFeeValueLb {
    if (!_payFeeValueLb) {
        _payFeeValueLb = [UILabel new];
        [_payFeeValueLb setFont:[UIFont systemFontOfSize:40]];
        [_payFeeValueLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_payFeeValueLb setText:@"1588"];
    }
    return _payFeeValueLb;
}

- (HMSecondEditionServiceOrderConfrimDetailView *)serviceDetailView {
    if (!_serviceDetailView) {
        _serviceDetailView = [HMSecondEditionServiceOrderConfrimDetailView new];
    }
    return _serviceDetailView;
}

- (HMSecondEditionPayWayViewController *)payWayVC {
    if (!_payWayVC) {
        _payWayVC = [[HMSecondEditionPayWayViewController alloc] initWithServiceDetail:self.serviceDetail];
        [_payWayVC setNeedMsgItems:self.needMsgItems];
        
    }
    return _payWayVC;
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
