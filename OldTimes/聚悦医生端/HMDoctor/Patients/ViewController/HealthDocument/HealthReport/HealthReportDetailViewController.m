//
//  HealthReportDetailViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthReportDetailViewController.h"
#import "HealthReportInfo.h"
#import "ClientHelper.h"

@interface HealthReportDetailViewController ()
<UIWebViewDelegate>
{
   // HealthReport* report;
    NSString* healthyReportId;
    UIWebView* webview;
}
@end

@implementation HealthReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"健康报告"];
    
    if (self.paramObject)
    {
        if ([self.paramObject isKindOfClass:[NSString class]])
        {
            healthyReportId = self.paramObject;
        }
        
    }
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
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    NSString *str = [NSString stringWithFormat:@"%@/dealWithHealthyReport.htm?vType=YS&healthyReportId=%@&staffUserId=%ld",kZJKHealthDataBaseUrl, healthyReportId ,curUser.userId];
    
    NSString *encodedStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedStr]];
    [webview showWaitView];
    [webview setDelegate:self];
    [webview loadRequest:request];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[[request URL] absoluteString]stringByRemovingPercentEncoding];
    
    if ([requestString isEqualToString:@"exithtml5://HTML5.exit"])
    {
        [self.navigationController popViewControllerAnimated:YES];
//        self.navigationController pop
        
        return NO;
    }
    return YES;
}


- (void) webViewDidStartLoad:(UIWebView *)webView
{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    StaffPrivilegeJSHelper* privilegeHelper = [StaffPrivilegeJSHelper new];
    context[@"h5_js"]=privilegeHelper;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [webView closeWaitView];
    
}

@end

@interface HealthReportEditViewController ()
<UIWebViewDelegate>
{
    HealthReportInfo* reportInfo;
    NSString* healthyReportId;
    UIWebView* webview;
}

@end

@implementation HealthReportEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"健康报告"];
    
    if (self.paramObject)
    {
        if ([self.paramObject isKindOfClass:[HealthReportInfo class]])
        {
            reportInfo = self.paramObject;
        }
        
    }
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
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSString *str = [NSString stringWithFormat:@"%@/editDealWithHealthyReport.htm?vType=YS&healthyReportId=%@&staffUserId=%ld&staffId=%ld&userId=%ld",kZJKHealthDataBaseUrl, reportInfo.healthyReportId ,staff.userId, staff.staffId, reportInfo.userId];
    
    NSString *encodedStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedStr]];
    [webview showWaitView];
    [webview setDelegate:self];
    [webview loadRequest:request];
    
}


#pragma mark -- WebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[[request URL] absoluteString]stringByRemovingPercentEncoding];
    
    if ([requestString isEqualToString:@"exithtml5://HTML5.exit"])
    {

        [self.navigationController popViewControllerAnimated:YES];
        
        return NO;
    }
    return YES;
}


- (void) webViewDidStartLoad:(UIWebView *)webView
{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    StaffPrivilegeJSHelper* privilegeHelper = [StaffPrivilegeJSHelper new];
    context[@"h5_js"]=privilegeHelper;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [webView closeWaitView];
    
}

@end

