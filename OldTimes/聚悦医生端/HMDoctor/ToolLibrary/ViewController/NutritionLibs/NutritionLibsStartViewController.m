//
//  NutritionLibsStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NutritionLibsStartViewController.h"
#import "ClientHelper.h"

@interface NutritionLibsStartViewController ()
<UIWebViewDelegate>
{
    UIWebView* webview;
}
@end

@implementation NutritionLibsStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"营养库"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (webview)
    {
        return;
    }
    webview = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webview];
    
    [webview showWaitView];
    [webview setDelegate:self];
    [webview.scrollView setShowsVerticalScrollIndicator:NO];
    [webview sizeToFit];
    [webview scalesPageToFit];
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
//    NSString* requestUrl = [NSString stringWithFormat:@"%@/yyk.htm?vType=YS&userId=%ld", kZJKHealthDataBaseUrl, curUser.userId];
    NSString* requestUrl = [NSString stringWithFormat:@"%@/yyk.htm?vType=YS&userId=%ld", kZJKHealthDataBaseUrl, curUser.userId];
    
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];

}

//- (void) viewDidAppear:(BOOL)animated
//{
//    if (webview)
//    {
//        return;
//    }
//    webview = [[UIWebView alloc]initWithFrame:self.view.bounds];
//    [self.view addSubview:webview];
//    
//    [webview showWaitView];
//    [webview setDelegate:self];
//    [webview.scrollView setShowsVerticalScrollIndicator:NO];
//    [webview sizeToFit];
//    [webview scalesPageToFit];
//    
//    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
//    NSString* requestUrl = [NSString stringWithFormat:@"%@/yyk.htm?userId=%ld", kZJKHealthDataBaseUrl, curUser.userId];
//    
//    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
//}


- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [webView closeWaitView];
    
}
@end
