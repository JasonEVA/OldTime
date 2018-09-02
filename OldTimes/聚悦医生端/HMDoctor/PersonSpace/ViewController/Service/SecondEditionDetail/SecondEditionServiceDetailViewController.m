//
//  SecondEditionServiceDetailViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/7/5.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SecondEditionServiceDetailViewController.h"
#import "ServiceInfo.h"
#import "ClientHelper.h"
#import <WebKit/WebKit.h>

@interface SecondEditionServiceDetailViewController ()
{
    ServiceInfo* serviceInfo;
    
}

@property (nonatomic, readonly) WKWebView* webview;
@end

@implementation SecondEditionServiceDetailViewController
@synthesize webview = _webview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"服务详情"];
    if (self.paramObject && [self.paramObject isKindOfClass:[ServiceInfo class]])
    {
        serviceInfo = (ServiceInfo*)self.paramObject;
    }
    
    NSString* urlString = [NSString stringWithFormat:@"%@/fwx/detail.htm?upId=%ld&fromapp=Y&vType=YS",kBaseShopUrl, serviceInfo.upId];
    
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    if (curUser && curUser.userId > 0) {
        urlString = [urlString stringByAppendingFormat:@"&userId=%ld", curUser.userId];
    }

    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* startUrl = [NSURL URLWithString:urlString];
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:startUrl]];
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

#pragma mark settingAndGetting
- (WKWebView*) webview
{
    if (!_webview) {
        _webview = [[WKWebView alloc] init];
        [self.view addSubview:_webview];
    }
    return _webview;
}

@end
