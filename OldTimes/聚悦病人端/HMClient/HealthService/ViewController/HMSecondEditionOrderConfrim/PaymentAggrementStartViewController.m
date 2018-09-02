//
//  PaymentAggrementStartViewController.m
//  HMClient
//
//  Created by yinquan on 2017/6/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PaymentAggrementStartViewController.h"

@interface PaymentAggrementStartViewController ()

@property (nonatomic, readonly) UIWebView* webview;
@end

@implementation PaymentAggrementStartViewController
@synthesize webview = _webview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"聚悦健康支付协议"];
    
    NSURL* url = [NSURL URLWithString:@"http://182.92.8.118:10008/jkglsc/newc/order/zfxy.htm"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - settingAndGetting
- (UIWebView*) webview
{
    if (!_webview) {
        _webview = [[UIWebView alloc] init];
        [self.view addSubview:_webview];
        
        [_webview.scrollView setShowsVerticalScrollIndicator:NO];
        [_webview sizeToFit];
        [_webview scalesPageToFit];
    }
    return _webview;
}

@end
