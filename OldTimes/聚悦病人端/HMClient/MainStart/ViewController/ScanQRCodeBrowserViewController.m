//
//  ScanQRCodeBrowserViewController.m
//  HMClient
//
//  Created by lkl on 16/8/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ScanQRCodeBrowserViewController.h"

@interface ScanQRCodeBrowserViewController ()<UIWebViewDelegate>
{
    UIWebView *webview;
    NSString  *requestUrl;
}
@end

@implementation ScanQRCodeBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]])
    {
        requestUrl = (NSString *)self.paramObject;
    }
    
    webview = [[UIWebView alloc]init];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [webview setDelegate:self];
    [webview setScalesPageToFit:YES];
    [webview loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [webview closeWaitView];
    if ([error code] == NSURLErrorCancelled)
    {
        return;
    }
    [self showAlertMessage:[NSString stringWithFormat:@"%@",error]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [webview showWaitView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webview closeWaitView];
    [self setTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
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
