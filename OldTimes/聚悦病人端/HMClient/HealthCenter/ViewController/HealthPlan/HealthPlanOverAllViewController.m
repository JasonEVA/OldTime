//
//  HealthPlanOverAllViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthPlanOverAllViewController.h"
#import "ClientHelper.h"

@interface HealthPlanOverAllViewController ()
<UIWebViewDelegate>
{
    UIWebView* webview;
}
@end

@implementation HealthPlanOverAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!webview)
    {
        webview = [[UIWebView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:webview];
        
//        [webview showWaitView];
        [webview setDelegate:self];
        [webview.scrollView setShowsVerticalScrollIndicator:NO];
        [webview sizeToFit];
        [webview scalesPageToFit];
        
        UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
        NSString* requestUrl = [NSString stringWithFormat:@"%@/userHealthyPlanDets.htm?vType=YH&id=%ld", kZJKHealthDataBaseUrl, curUser.userId];
        //NSString* requestUrl = [NSString stringWithFormat:@"http://10.0.0.117:7003/jkjh_gw_hzlb.htm?staffId=2022222&staffRole=adviser"];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
//    [webView closeWaitView];
    
}
@end
