//
//  StaffServiceQRCodeViewController.m
//  HMDoctor
//
//  Created by lkl on 16/8/1.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "StaffServiceQRCodeViewController.h"
#import "ServiceInfo.h"
#import "ClientHelper.h"

@interface StaffServiceQRCodeViewController ()<UIWebViewDelegate>
{
    UIWebView* webview;
    
    NSInteger staffId;
    NSInteger upId;
}

@end

@implementation StaffServiceQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"我的二维码"];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[ServiceInfo class]])
    {
        ServiceInfo *service = (ServiceInfo*)self.paramObject;
        upId = service.upId;
    }
    
    webview = [[UIWebView alloc]init];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    if (curStaff)
    {
        staffId = curStaff.staffId;
    }
    
    NSString *str = [NSString stringWithFormat:@"%@/newc/ruz/ruz_phone.htm?staffId=%ld&upId=%ld",kZJKHealthDataBaseUrl, staffId, upId];
    NSString *encodedStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedStr]];
    [webview setDelegate:self];
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
}

@end
