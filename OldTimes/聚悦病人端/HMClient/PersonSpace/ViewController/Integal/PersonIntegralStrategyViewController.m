//
//  PersonIntegralStrategyViewController.m
//  HMClient
//
//  Created by yinquan on 2017/7/18.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PersonIntegralStrategyViewController.h"
#import <WebKit/WebKit.h>
#import "ClientHelper.h"

@interface PersonIntegralStrategyViewController ()

@property (nonatomic, strong) WKWebView* webView;
@end

@implementation PersonIntegralStrategyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"积分攻略"];
    
    NSString* strategyUrl = [NSString stringWithFormat:@"%@/newc/jifen/jfgl.htm", kZJKHealthDataBaseUrl];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strategyUrl]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - settingAndGetting

- (WKWebView*) webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _webView;
}
@end
